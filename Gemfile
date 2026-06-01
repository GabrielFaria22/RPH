source "https://rubygems.org"

ruby "3.2.2"

# Core
gem "rails", "~> 7.1.6"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

# Authentication
gem "devise", "~> 4.9"
gem "devise-jwt", "~> 0.11"

# API & Serialization
gem "blueprinter", "~> 1.0"
gem "oj", "~> 3.16"
gem "rack-cors", "~> 2.0"
gem "ransack", "~> 4.4"

# Background Jobs
gem "sidekiq", "~> 7.2"
gem "redis", "~> 5.0"

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails", "~> 6.1"
  gem "rswag-specs", "~> 2.16"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.2"
  gem "dotenv-rails", "~> 3.1"
end

group :development do
  gem "annotate", "~> 3.2"
  gem "rswag-api", "~> 2.16"
  gem "rswag-ui", "~> 2.16"
end
