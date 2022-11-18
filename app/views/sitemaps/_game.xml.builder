xml << render('url',
              params: {
                url: method(:game_url),
                url_params: { id: game.slug },
                priority: 1, freq: 'weekly',
                image: {
                  url: game.image,
                  title: game.title,
                  caption: game.seo_description
                }
              })
