load 'deploy' if respond_to?(:namespace)

set :application, "blog"
set :user, "bkrsta"
set :use_sudo, false

set :scm, :git
set :repository, "git@srv1:apps/blog.git"
set :deploy_via, :checkout
set :deploy_to, "/stor/www/public/bkrsta.co.cc/apps/#{application}"

role :app, "srv1"
role :web, "srv1"
role :db, "srv1", :primary => true

set :runner, user
set :admin_runner, user

namespace :deploy do
  task :start, :roles => [:web, :app] do
    run "cd #{deploy_to}/current && nohup thin -C thin/production_config.yml -R config.ru start"
  end

  task :stop, :roles => [:web, :app] do
    run "cd #{deploy_to}/current && nohup thin -C thin/production_config.yml -R config.ru stop"
  end

  task :restart, :roles => [:web, :app] do
    deploy.stop
    deploy.start
  end

  # This will make sure that Capistrano doesn't try to run rake:migrate (this is not a Rails project!)
  task :cold do
    deploy.update
    deploy.start
  end
end

namespace :heroku do
  task :deploy, :roles => [] do
    system "git push heroku master"
  end

  task :staging, :roles => [] do
    system "git push heroku-staging staging:master"
  end

  task :default, :roles => [] do
    heroku.deploy
  end
end

namespace :app do
  task :log do
    run "cat #{deploy_to}/current/log/thin.log"
  end
end
