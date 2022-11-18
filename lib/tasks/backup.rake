# frozen_string_literal: true

namespace :db do
  desc 'Dumps the database to backups'
  task dump: :environment do
    cmd = nil
    with_config do |_app, host, db, _user|
      filename = dump_filename db, Time.zone.now.strftime('%Y%m%d%H%M%S')
      cmd = "pg_dump -U postgres -F c -v -h #{host} -d #{db} -f #{filename}"
    end
    puts cmd
    exec cmd
  end

  desc 'Restores the database from backups'
  task :restore, %i[date clean] => :environment do |_task, args|
    if args.date.present?
      cmd = nil
      with_config do |_app, _host, db, _user|
        if args.clean
          Rake::Task['db:drop'].invoke
          Rake::Task['db:create'].invoke
          filename = dump_filename db, args.date
          cmd = "pg_restore -j 3 -x -O -F c --dbname=#{db} #{filename}"
        else
          filename = dump_filename db, args.date
          cmd = "pg_restore -j 3 -a -x -O -F c --dbname=#{db} #{filename}"
         end
      end
      puts cmd
      exec cmd
    else
      puts 'Please pass a date to the task'
    end
  end

  private

  def dump_filename(db, date)
    "#{Rails.root}/backups/#{date}_#{db}.psql"
  end

  def with_config
    yield Rails.application.class.parent_name.underscore,
    ActiveRecord::Base.connection_config[:host],
    ActiveRecord::Base.connection_config[:database],
    ActiveRecord::Base.connection_config[:username]
  end
end
