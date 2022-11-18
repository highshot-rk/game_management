module ImageBuilder
  class Cache
    class <<self
      def run_or_load_cached(key, clean: false)
        ensure_temp_dir!
        file_name = "#{temp_dir}/#{Digest::MD5.hexdigest(key)}.png"
        if !clean && File.exist?(file_name)
          ImageWrapper.new(file_name)
        else
          ImageWrapper.new(yield(file_name))
        end
      end

      private

      def ensure_temp_dir!
        FileUtils.mkdir_p(temp_dir) unless File.exist? temp_dir
      end

      def temp_dir
        ImageBuilder::Config.current[:temp_dir]
      end
    end
  end
end
