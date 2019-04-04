threads_count = ENV.fetch('PUMA_MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count

environment ENV.fetch('RACK_ENV') { 'development' }
