xml << render('url',
              params: {
                url: method(:user_url),
                url_params: { id: user.username },
                priority: 0.7, freq: 'yearly'
              })
