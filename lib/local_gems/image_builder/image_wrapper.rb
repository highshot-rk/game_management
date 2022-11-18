module ImageBuilder
  class ImageWrapper
    attr_reader :image
    def initialize(file)
      if file.is_a? String
        @image = MiniMagick::Image.new(file)
      else
        @image = file
      end
    end

    def append(image, options = { x: 0, y: 0 })
      return append(image.image, options) if image.is_a?(ImageWrapper)
      decorate(
        composite(image) do |c|
          c.compose 'Over'
          c.geometry "+#{options[:x]}+#{options[:y]}"
        end)
    end

    delegate :path, to: :image

    def method_missing(name, *args, &block)
      if image.respond_to?(name)
        image.__send__(name, *args, &block)
      else
        super
      end
    end

    def decorate(image)
      ImageWrapper.new(image)
    end
  end
end
