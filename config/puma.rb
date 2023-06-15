threads_count = ENV.fetch("PUMA_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

port        ENV.fetch("PUMA_PORT") { 9292 }
environment ENV.fetch("RACK_ENV") { "development" }

log_requests true
