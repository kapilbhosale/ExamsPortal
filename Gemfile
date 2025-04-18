source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'

gem 'rack-cors'
# Use pg as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby


gem 'activeadmin'
gem 'activeadmin_json_editor', '~> 0.0.7'
gem 'base32', '~> 0.3.2'
gem 'rotp'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# gem 'sucker_punch', '~> 2.0'
gem 'sidekiq'
gem "sidekiq-cron", "~> 1.1"

gem 'webpacker'
gem 'foreman'
gem "audited"

gem "twitter-bootstrap-rails"

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem "react_on_rails", "= 10.0.2"
gem 'devise'
gem 'kaminari'
gem 'ransack'
gem 'carrierwave'
# gem 'carrierwave-aws'
gem 'fog-aws'
gem 'mini_magick'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', '= 0.12.3'
gem 'chartkick'
gem 'prawn'
gem 'prawn-table'

gem 'rubyzip', '>= 1.0.0' # will load new rubyzip version
gem 'zip-zip' # will load compatibility for old rubyzip API.
gem 'aws-sdk-s3'
gem 'file_validators'
gem "roo", "~> 2.8.0"
gem "axlsx"

gem 'jquery-rails'

# redis added for caching
gem 'redis'
gem 'redis-rails'
gem 'hiredis'
gem 'redis-store'
gem 'activerecord-import'

#monitoring gems
# gem 'scout_apm'
# gem 'newrelic_rpm'

group :production do
  gem 'rmagick'
end
gem "mini_magick"

gem 'figaro'
gem 'fcm'
gem 'faraday'
# gem 'youtube_it'

gem "paranoia", "~> 2.2"

gem 'razorpay'
gem 'annotate'
gem 'jwt'
gem 'rqrcode'
gem 'prawn-qrcode'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'hirb'
  gem 'awesome_print'
  gem 'pry-nav'
  gem 'rails-erd'
  gem 'pry'
  gem 'bullet'
  gem 'rb-readline'
  gem 'rubocop'
  # gem 'rollbar'

  # gem 'sshkit-sudo'
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  # gem 'capistrano-sidekiq', require: false, git: 'https://github.com/seuros/capistrano-sidekiq', branch: 'master'

  # deployment gems
  # gem 'mina'
  # gem 'mina-puma', require: false,  github: 'untitledkingdom/mina-puma'
  # gem 'mina-nginx', :require => false
  gem 'rack-mini-profiler'
  gem 'ed25519'
  gem 'bcrypt_pbkdf'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
