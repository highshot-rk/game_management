module ImageBuilder
  class BannerGenerator < Generator
    def initialize(top, cult, latest)
      # imagefilledrectangle($image, 0, 0, 727, 89, IMG_COLOR_TILED);
      background = "#{Rails.root}/app/assets/images/banner/background.png"
      super(nil, background, text_options: { fill: '#CCCCCC' })
      @data = {
        top: top.map { |game| image_of(game) },
        cult: cult.map { |game| image_of(game) },
        latest: latest.map { |game| image_of(game) }
      }
    end

    def generate(regenerate = false)
      Cache.run_or_load_cached(@data.inspect, clean: regenerate) do |filename|
        generate_banner
        current.write(filename)
        current
      end.path
    end

    def generate_banner
      put_screens(@data[:top], distance: 137)
      put_screens(@data[:cult], distance: 137)
      put_screens(@data[:latest], distance: 137)
    end

    def put_screens(screens, distance: 0, offset: 0)
      screens.each_with_index do |screen, i|
        put_screen(screen, x: distance * i + offset)
      end
    end

    def put_screen(screen, x: 0, y: 0, width: 133, height: 89)
      # imagecopyresampled($image, $screenshot1, 0, 0, 0, 0, 133, 89, imagesx($screenshot1), imagesy($screenshot1));
      # imagecopyresampled($image, $screenshot2, 137, 0, 0, 0, 133, 89, imagesx($screenshot2), imagesy($screenshot2));
      # imagecopyresampled($image, $screenshot3, 274, 0, 0, 0, 133, 89, imagesx($screenshot3), imagesy($screenshot3));
      key = [screen, width, height].inspect
      image = Cache.run_or_load_cached(key) do |filename|
        file = MiniMagick::Image.open(screen)
        resize_and_crop! file, width, height
        file.write(filename)
        file
      end
      append(image, x: x, y: y)
    end

    private

    def image_of(game)
      game.screen.try(:path) ||
        "#{Rails.root}/app/assets/images/Files/NoScreen.png"
    end
  end
end
