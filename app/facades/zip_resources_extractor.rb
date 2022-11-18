require 'zip'

class ZipResourcesExtractor
  class Error < ::StandardError; end
  class FileNotFoundInArchiveError < Error; end

  attr_reader :file_name, :file_to_find

  def initialize(file_name, file_to_find, temp_dir: nil)
    @file_name = file_name
    @file_to_find = file_to_find
    @temp_dir = temp_dir || "#{Rails.root}/public/html5/"
  end

  def contains_file?
    @found_file ||= find_file_in_zip
  end

  def extract!(path)
    fail FileNotFoundInArchiveError unless contains_file?
    extract_and_prepare(path)
    File.basename(@found_file.name)
  end

  private

  def find_file_in_zip
    return nil if file_name.blank?
    Zip::File.open(file_name) do |files|
      return files.detect do |entry|
        file_name_matches?(entry)
      end
    end
  rescue Zip::Error
    nil
  end

  def file_name_matches?(file)
    case file_to_find
    when Regexp
      file.name =~ file_to_find
    else
      File.basename(file.name) == file_to_find
    end
  end

  def extract_and_prepare(destination)
    create_dir_safely destination
    unzip(file_name, destination)
    fix_nested_dir(destination, @found_file) if @found_file.name != File.basename(@found_file.name)
  end

  def fix_nested_dir(directory, index_file)
    html_file_dirname = File.dirname(index_file.name)
    temp_dir = "#{@temp_dir}#{SecureRandom.uuid}"

    system_or_fail "mv #{directory}/#{esc(html_file_dirname)} #{temp_dir}"
    system_or_fail "rm -rf #{directory}"
    system_or_fail "mv #{temp_dir} #{directory}"
  end

  def unzip(file_name, directory)
    base_name = File.basename(file_name)

    system_or_fail "cp #{esc(file_name)} #{directory}"
    system_or_fail(
      "cd #{directory}\n"\
      "unzip #{esc(base_name)}\n"\
      "rm #{esc(base_name)}")
  end

  def esc(string)
    Shellwords.escape(string)
  end

  def system_or_fail(string)
    system(string) || fail("Command `#{string}` has failed!")
  end

  def create_dir_safely(directory)
    FileUtils.rm_rf(directory)
    FileUtils.mkdir_p directory
  end
end
