module DownloadLinkHelper
  def link_to_download_link(download_link, &block)
    options = {id: 'Botton', class: 'download-button', rel: 'nofollow', data: { action: 'player-increment', url: counter_api_v1_download_link_url(download_link), target: '#playersCount', analytics_click: 'Game Download' }, target: '_blank'}
    options[:download] = download_link.game.title if !download_link.url
    link_to download_link_url(download_link.id), options, &block
  end
end
