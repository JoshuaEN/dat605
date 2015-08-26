source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# For logging in from other providers
gem 'omniauth'
gem "omniauth-google-oauth2"

gem 'nokogiri'

gem 'kaminari'

group :production do
	gem 'mysql2'
end

group :development, :test do
  gem 'thin'
  gem "better_errors", '1.1.0'
  gem 'binding_of_caller', '0.7.2'
  gem 'pg' # postgresql is what I have installed locally

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
