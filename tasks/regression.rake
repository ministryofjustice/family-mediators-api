namespace :regression do
  desc "Smoke-test the mediator data upload journey (start -> login -> upload -> " \
       "check file mediator count -> process -> check success record count) against " \
       "a deployed Family Mediators API environment. Automates the manual regression " \
       "script. WARNING: processing a spreadsheet replaces ALL existing mediator " \
       "records in the target environment - do not point this at production without " \
       "being sure that's what you want. Prompts interactively (press Enter to accept " \
       "the default shown, where there is one) for anything not already set via env " \
       "var: FMA_STAGING_URL (defaults to the CloudPlatform staging host), " \
       "FMA_BASIC_AUTH_USER / FMA_BASIC_AUTH_PASS (if the environment is behind Basic " \
       "Auth), FMA_LOGIN_USER / FMA_LOGIN_PASSWORD (the app's own login, required), " \
       "FMA_SPREADSHEET_PATH (required, path to the .xlsx file to upload), " \
       "FMA_HEADLESS=false (to watch it run). Never commit real values for these. " \
       "Pass FMA_DEFAULT=true to skip the 'use defaults?' prompt and answer yes " \
       "automatically - Rake treats --default as its own CLI flag and will reject it, " \
       "so it can't be passed that way."
  task :live_upload_check do
    require "capybara"
    require "selenium-webdriver"
    require "rubyXL"
    require "uri"
    require "io/console"
    require "fileutils"
    require "active_support/core_ext/string/access" # String#last, used by Admin::Processing::RecordRemover
    require_relative "../lib/admin/processing/headings"
    require_relative "../lib/admin/processing/record_remover"
    require_relative "../lib/admin/parsers/workbook"

    use_defaults = %w[true 1 yes y].include?(ENV["FMA_DEFAULT"].to_s.downcase)
    if !use_defaults && $stdin.tty?
      print "Use default values for everything except credentials and the spreadsheet? [Y/n]: "
      answer = $stdin.gets&.chomp
      use_defaults = answer.nil? || answer.strip.empty? || !answer.strip.downcase.start_with?("n")
    end

    # Falls back to an interactive prompt (masked for `secret`, Enter accepts the
    # default shown) only when the env var is unset and we have a real terminal.
    # Fields with an actual default value are skipped entirely (silently using it)
    # when `use_defaults` was accepted above - fields with no default (e.g. Basic
    # Auth and credentials, which have nothing safe to fall back to) still get asked.
    ask = lambda do |env_name, label, default: nil, secret: false, required: false|
      env_value = ENV[env_name]
      next env_value unless env_value.to_s.empty?
      next default if use_defaults && !required && !default.nil?
      next default unless $stdin.tty?

      default_hint = if default
                       " [#{secret ? 'hidden' : default}]"
                     end
      print "#{label}#{default_hint}: "
      input = secret ? $stdin.noecho(&:gets) : $stdin.gets
      puts if secret
      value = input&.chomp
      value.to_s.empty? ? default : value
    end

    base_url = ask.call(
      "FMA_STAGING_URL", "Environment URL",
      default: "https://family-mediators-api-staging.apps.live.cloud-platform.service.justice.gov.uk"
    )
    basic_auth_user = ask.call("FMA_BASIC_AUTH_USER", "Basic Auth username (blank if none)")
    basic_auth_pass = ask.call("FMA_BASIC_AUTH_PASS", "Basic Auth password (blank if none)", secret: true)
    login_user = ask.call("FMA_LOGIN_USER", "App login username", required: true) ||
      abort("Set FMA_LOGIN_USER to the admin username for the target environment")
    login_password = ask.call("FMA_LOGIN_PASSWORD", "App login password", secret: true, required: true) ||
      abort("Set FMA_LOGIN_PASSWORD to the admin password for the target environment")
    spreadsheet_path = ask.call("FMA_SPREADSHEET_PATH", "Path to mediators .xlsx file", required: true) ||
      abort("Set FMA_SPREADSHEET_PATH to the spreadsheet you want to upload")
    headless = ask.call("FMA_HEADLESS", "Run headless? (true/false)", default: "false") != "false"

    abort("No such file: #{spreadsheet_path}") unless File.exist?(spreadsheet_path)

    # Reuses the app's own parser (blank-row and student-URN removal included) so
    # this count can never drift from what the live app itself will report.
    expected_count = begin
      mediators, = Admin::Parsers::Workbook.new(RubyXL::Parser.parse(spreadsheet_path)).call
      mediators.size
    rescue StandardError => e
      abort("Could not read #{spreadsheet_path}: #{e.message}")
    end

    puts
    puts "This will REPLACE ALL existing mediator records in #{base_url} with the " \
         "#{expected_count} record(s) from #{spreadsheet_path}."
    unless use_defaults
      print "Continue? [y/N]: "
      abort("Aborted.") unless $stdin.gets&.chomp&.downcase&.start_with?("y")
    end

    uri = URI.parse(base_url)
    uri.user = basic_auth_user if basic_auth_user
    uri.password = basic_auth_pass if basic_auth_pass
    app_host = uri.to_s

    Capybara.register_driver :regression_chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      if headless
        options.add_argument("--headless")
        options.add_argument("--disable-gpu")
        options.add_argument("--no-sandbox")
      end
      options.add_argument("--window-size=1280,1024")
      Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
    end

    Capybara.app_host = app_host
    Capybara.run_server = false
    Capybara.default_max_wait_time = 10

    session = nil

    begin
      puts
      puts "== Family Mediator API live regression check =="
      puts "Target: #{base_url}"
      puts "Spreadsheet: #{spreadsheet_path} (#{expected_count} data row(s))"
      puts

      session = Capybara::Session.new(:regression_chrome)
      session.visit("/")
      session.click_on("Start now")

      if session.has_field?("username")
        session.fill_in("username", with: login_user)
        session.fill_in("password", with: login_password)
        session.click_button("Login")
      end

      session.click_on("Upload now")
      session.attach_file("spreadsheet_file", File.expand_path(spreadsheet_path))
      session.click_button("Continue")

      unless session.has_content?("Check file details before processing the excel file")
        raise "FAIL: did not reach the file check page - #{session.html[0..500]}"
      end

      match = session.text.match(/File mediator count:\s*(\d+)/)
      file_mediator_count = match && match[1].to_i
      puts "File mediator count shown: #{file_mediator_count} (spreadsheet has #{expected_count})"
      raise "FAIL: file mediator count (#{file_mediator_count}) does not match the spreadsheet (#{expected_count})" if file_mediator_count != expected_count

      session.click_button("Process data and apply updates")

      unless session.has_content?("Spreadsheet upload complete")
        raise "FAIL: did not reach the upload-complete page - #{session.html[0..500]}"
      end

      match = session.text.match(/(\d+) records successfully written to the database/)
      written_count = match && match[1].to_i
      raise "FAIL: could not find the 'records successfully written' count" unless written_count
      raise "FAIL: #{written_count} record(s) written, expected #{expected_count}" if written_count != expected_count

      puts
      puts "OK: #{written_count} record(s) written to the database."
      puts "Confirmation page: #{session.current_url}"
    rescue StandardError => e
      puts
      puts "FAILED: #{e.class}: #{e.message}"
      if session
        puts "Current URL: #{session.current_url}"
        timestamp = Time.now.strftime("%Y%m%d%H%M%S")
        FileUtils.mkdir_p("tmp")
        screenshot_path = File.join("tmp", "regression_failure_#{timestamp}.png")
        html_path = File.join("tmp", "regression_failure_#{timestamp}.html")
        session.save_screenshot(screenshot_path)
        File.write(html_path, session.html)
        puts "Screenshot saved to #{screenshot_path}"
        puts "Page HTML saved to #{html_path}"
      end
      raise
    ensure
      session&.driver&.quit
    end
  end
end
