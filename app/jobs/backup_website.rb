# frozen_string_literal: true

require 'net/ftp'

class BackupWebsite < ApplicationJob
  queue_as :default

  def perform
    `rake db:dump`

    Net::FTP.open(ENV['FTP_DOMAIN'], ENV['FTP_USER'], ENV['FTP_PASS']) do |ftp|
      ftp.chdir("#{ENV['FTP_DOMAIN']}/backups")
      ftp.putbinaryfile(latest_backup)
    end
  end

  private

  def latest_backup
    Dir.glob(File.join(Rails.root, 'backups', '*.*'))
       .max { |a, b| File.ctime(a) <=> File.ctime(b) }
  end
end
