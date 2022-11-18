module ImageBuilder
  class Generator
    attr_reader :subject, :text_writer, :current

    def initialize(subject, background_file, options = {})
      @current = ImageWrapper.new(background_file)
      @subject = subject
      @text_writer = TextWriter.new(options[:text_options] || {})
    end

    def generate
      fail NotImplementedError
    end

    def append(*args)
      @current = @current.append(*args)
    end

    def resize_and_crop!(image, width, height)
      image.combine_options do |b|
        b.resize "#{width}x#{height}^"
        b.gravity 'center'
        b.crop "#{width}x#{height}+0+0"
      end
    end

    delegate :write_or_cached, to: :text_writer
  end
end
