module ImageBuilder
  class TextWriter
    def initialize(defaults = {})
      @defaults = ImageBuilder::Config.current[:text].merge defaults
    end

    def write_or_cached(text, params = {})
      array_params = format_params(params, text)
      Cache.run_or_load_cached([text, array_params].inspect) do |filename|
        write(filename, array_params)
      end
    end

    def write(file_name, params)
      MiniMagick::Tool::Convert.new do |convert|
        convert.merge! params
        convert << file_name
      end
      MiniMagick::Image.new(file_name)
    end

    private

    def format_params(params, text)
      @defaults.merge(params)
        .map { |k, v| ["-#{k}", v.to_s] }.flatten + ["label:#{text}"]
    end
  end
end
