source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.1.5'
gem 'rack-rewrite'
gem 'jquery-rails'
gem 'pg'
gem "rmagick", :require => 'RMagick'
gem "RedCloth", ">= 4.0", :require => 'redcloth'
gem 'protected_attributes'
gem 'newrelic_rpm'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer', :platform => :ruby
  gem 'less-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'thin'
  gem 'rails_12factor'
end
