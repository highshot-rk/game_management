module ImageBuilder
  class Config
    class <<self
      def current
        @current ||= default
      end

      def default
        {
          temp_dir: "#{Rails.root}/tmp/banner",
          text: {
            background: 'none',
            font: "#{Rails.root}/app/assets/images/banner/Arial.ttf",
            pointsize: '10'
          }
        }
      end
    end
  end
end
