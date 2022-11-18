# frozen_string_literal: true
class IndiepadInjector
  def initialize(path)
    @path = path
    @file = File.read(@path)
    @document = Nokogiri::HTML(@file)
  end

  def inject!
    head = @document.css('head')[0]
    head = create_head! unless head
    return unless head
    head.add_child('<script type="text/javascript">document.domain = "indiexpo.net"</script>')
    File.write(@path, @document.to_html)
  end

  private

  def create_head!
    html = @document.css('html').first
    html.prepend_child('<head></head>') if html

    @document.css('head').first
  end
end
