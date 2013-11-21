require 'bundler/capistrano'
#require 'rvm/capistrano'
#set :rvm_ruby_string, 'ruby-1.9.3'
#

#set :ssh_options, {:forward_agent => true }

set :ssh_options, {:auth_methods => "publickey"}
set :ssh_options, {:keys => "/usr/local/election-ec2-andreea.pem"}

set :deploy_to, "~/deploy/cap2_test"

set :default_environment, {
  'PATH' => "#{deploy_to}/bin:$PATH",
  'GEM_HOME' => "#{deploy_to}/gems" 
 }

set :user, 'ec2-user'
set :application, "cap2_test"
set :domain, '54.200.231.24'
set :applicationdir, "~/deploy/cap2_test"

set :scm, :git
set :repository,  "git@github.com:andreeasgw/cap2_test.git"
set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false
#set :deploy_via, :remote_cache

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "54.200.231.24"                          # Your HTTP server, Apache/etc
role :app, "54.200.231.24"                          # This may be the same as your `Web` server
role :db,  "54.200.231.24", :primary => true # This is where Rails migrations will run
role :db,  "54.200.231.24"

default_run_options[:pty] = true
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end

 namespace :gems do
   task :bundle, :roles => :app do
       run "cd #{release_path} && bundle install  --deployment --without development test"
    end
  end
after "deploy:update_code", "gems:bundle"

