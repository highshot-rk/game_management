xml << render('url',
              params: {
                url: method(:event_url),
                url_params: { id: event.slug },
                priority: 0.8, freq: 'weekly',
                image: {
                  url: event.image,
                  title: event.title,
                  caption: event.seo_description
                }
              })
