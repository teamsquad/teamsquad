# Redirect www subdomain to subdomain less variant (to keep canonical domain for main site)

require "rack-rewrite"

ENV['RACK_ENV'] ||= 'development'

if ENV['RACK_ENV'] == 'development'
  ENV['SITE_URL'] = 'teamsquad.dev'
else
  ENV['SITE_URL'] = 'teamsquad.com'
end

use Rack::Rewrite do
  r301 %r{.*}, "http://#{ENV['SITE_URL']}$&", :if => Proc.new { |rack_env| rack_env['SERVER_NAME'].start_with?('www')}
  r301 %r{^(.+)/$}, '$1'
end

# Start up Rails app

require ::File.expand_path('../config/environment',  __FILE__)
run Teamsquad::Application
