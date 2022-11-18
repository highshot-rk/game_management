
desc 'Dumps the database to backups'
task import_resources: :environment do
  Game.find_each do |game|
    3.times do |i|
      check_and_create_image game, i, 'artworks'
    end
    3.times do |i|
      check_and_create_image game, i, 'screens'
    end
  end
end

def check_and_create_image(game, i, name)
  folder_name = name == 'artworks' ? 'Artworks' : 'Screenshots'
  file_name = "#{Rails.root}/public/Games/#{game.id}/#{folder_name}/#{i}.jpg"
  return unless File.exist? file_name
  stats = file_stats(file_name)
  new_file_name = stats[:file_content_type] =~ /png\Z/ ? "#{i}.png" : "#{i}.jpg"
  resource = game.send(name).create(stats.merge(file_file_name: new_file_name))
  FileUtils.mkdir_p(File.dirname(resource.file.path))
  FileUtils.cp file_name, resource.file.path
end

def file_stats(file_name)
  stat = File.stat(file_name)
  {
    file_content_type: `file --mime-type -b #{file_name}`.strip,
    file_file_size: stat.size,
    file_updated_at: stat.ctime
  }
end
