module ImageBuilder
  class SignatureGenerator < Generator
    def initialize(subject)
      background = "#{Rails.root}/app/assets/images/banner/background.png"
      super(subject, background, text_options: { fill: '#CCCCCC' })
      @data = {
        title: subject.title,
        downloads_count: subject.downloads_count,
        ratings_avg: subject.ratings_avg,
        chart_position: subject.chart_position(:ratings_avg),
        followings_count: subject.followings_count,
        game_image: game_image
      }
    end

    def generate(regenerate = false)
      Cache.run_or_load_cached(@data.inspect, clean: regenerate) do |filename|
        generate_no_cache
        current.write(filename)
        current
      end.path
    end

    def generate_no_cache
      write_game_title
      write_downloads
      write_rating
      write_chart
      write_followers
      add_screen
    end

    def write_game_title
      text = write_or_cached(subject.title, pointsize: 17)
      append(text, x: 158, y: 13)
    end

    def write_downloads
      text = write_or_cached("#{subject.downloads_count}", pointsize: 12)
      append(text, x: 190, y: 47)
    end

    def write_rating
      formatted_rating = '%.1f' % subject.ratings_avg.to_f
      text = write_or_cached("#{formatted_rating}", pointsize: 12)
      append(text, x: 190, y: 74)
    end

    def write_chart
      text = write_or_cached(
        "#{subject.chart_position(:ratings_abs)}°", pointsize: 12)
      append(text, x: 260, y: 47)
    end

    def write_followers
      text = write_or_cached("#{subject.followings_count}", pointsize: 12)
      append(text, x: 260, y: 74)
    end

    def add_screen
      key = [game_image, 140, 80].inspect
      image = Cache.run_or_load_cached(key) do |filename|
        file = MiniMagick::Image.open(game_image)
        resize_and_crop! file.frames.first, 140, 80
        file.write(filename)
        file
      end
      append(image, x: 10, y: 10)
    end

    def game_image
      image_path = subject.screen&.file&.path
      if image_path && File.exist?(image_path)
        image_path
      else
        Rails.root.join('app', 'assets', 'images', 'Files', 'NoScreen.png')
      end
    end
  end
end
