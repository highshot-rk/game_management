games.each do |game_data|
  xml << render('url', params: { url: ->(p) { game_url(p) }, url_params: { id: game_data[1] }, priority: 1, freq: 'weekly', category: 'Game', image: { url: game_icon, title: game_data[2], caption: game_data[3][0..160] } })
end
