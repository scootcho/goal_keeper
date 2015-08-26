source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

#bootstrap-sass css components: https://github.com/twbs/bootstrap-sass
gem 'bootstrap-sass', '~> 3.3.5'

# vector icons: https://github.com/bokmann/font-awesome-rails
gem "font-awesome-rails" 

# Forms made easy for Rails! https://github.com/plataformatec/simple_form
gem 'simple_form'

# Adds form, image_tag, etc with filepicker.io in Rails. https://github.com/Ink/filepicker-rails
gem 'filepicker-rails'

# Javascript charts with one line of Ruby http://chartkick.com
gem "chartkick"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'rails_12factor', group: :production


group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'faker'
  gem 'launchy'
  gem 'database_cleaner'
end

group :development do
  gem 'pry'
  gem 'better_errors', '~> 1.1.0' # gives much better error messages for debug
  gem 'binding_of_caller', '~> 0.7.2' # helps out better_errors by giving you an interactive way to query variables and methods on the better_errors error screen
end
