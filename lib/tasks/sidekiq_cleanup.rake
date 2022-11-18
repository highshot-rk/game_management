namespace :sidekiq do
  task :cleanup do
    require 'sidekiq/api'
    # run a command which starts your packaging
    Sidekiq::Queue.all.map(&:clear)
  end
end

# every time you execute 'rake assets:precompile'
# run 'assets:erb:recompile' first
Rake::Task['db:drop'].enhance ['sidekiq:cleanup']
