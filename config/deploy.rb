# Deploy your application to TextDrive with...
#   rake deploy
#
# Or rollback with...
#   rake rollback

set :application, 'teamsquad'
set :user, "slatter"
set :txd_primary_domain, 'teamsquad.com'
set :lighty_port, 2541
set :repository, "http://#{txd_primary_domain}/svn/projects/#{application}/trunk"
set :deploy_to, "/home/#{user}/domains/#{application}"
set :scm, :subversion

role :app, txd_primary_domain 
role :web, txd_primary_domain
role :db, txd_primary_domain

desc "Restart lighty"
task :restart, :roles => :app do
  run "/home/#{user}/lighttpd/lighttpdctrl restart"
end

# Tasks may take advantage of several different helper methods to interact
# with the remote server(s). These are:
#
# * run(command, options={}, &block): execute the given command on all servers
#   associated with the current task, in parallel. The block, if given, should
#   accept three parameters: the communication channel, a symbol identifying the
#   type of stream (:err or :out), and the data. The block is invoked for all
#   output from the command, allowing you to inspect output and act
#   accordingly.
# * sudo(command, options={}, &block): same as run, but it executes the command
#   via sudo.
# * delete(path, options={}): deletes the given file or directory from all
#   associated servers. If :recursive => true is given in the options, the
#   delete uses "rm -rf" instead of "rm -f".
# * put(buffer, path, options={}): creates or overwrites a file at "path" on
#   all associated servers, populating it with the contents of "buffer". You
#   can specify :mode as an integer value, which will be used to set the mode
#   on the file.
# * render(template, options={}) or render(options={}): renders the given
#   template and returns a string. Alternatively, if the :template key is given,
#   it will be treated as the contents of the template to render. Any other keys
#   are treated as local variables, which are made available to the (ERb)
#   template.

# You can use "transaction" to indicate that if any of the tasks within it fail,
# all should be rolled back (for each task that specifies an on_rollback
# handler).

# desc "A task demonstrating the use of transactions."
# task :long_deploy do
#   transaction do
#     update_code
#     disable_web
#     symlink
#     migrate
#   end
# 
#   restart
#   enable_web
# end
# 
# desc "Used only for deploying when the spinner isn't running"
# task :cold_deploy do
#   transction do
#     update_code
#     symlink
#   end
# 
#   spinner
# end
