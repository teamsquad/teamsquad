# Deploy your application to TextDrive with...
#   cap deploy
#
# Or rollback with...
#   cap rollback
role :app, 'teamsquad.com'
role :web, 'teamsquad.com'
role :db, 'teamsquad.com'

set :application, 'teamsquad'
set :repository,"http://teamsquad.com/svn/projects/#{application}/trunk"
                   
set :user, "slatter"
set :deploy_to, "/home/#{user}/domains/#{application}"

desc "Restart lighty"
task :restart, :roles => :app do
  run "/home/#{user}/lighttpd/lighttpdctrl restart"
end

desc "Maintenance jobs to keep stuff tidy after deployment"
task :after_update_code, :roles => :app do
  run "ln -fhs #{shared_path}/uploads #{current_path}/public/uploads"
end