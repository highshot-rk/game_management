# frozen_string_literal: true
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  page_action :refresh_sitemap, method: :post do
    User.find_each(&:rebuild_sitemap_fragment!)
    Event.find_each(&:rebuild_sitemap_fragment!)
    Game.find_each(&:rebuild_sitemap_fragment!)
    redirect_to admin_dashboard_path, notice: 'Refreshed!'
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    # Here is an example of a simple dashboard with columns and panels.
    #

    columns do
      column do
        panel 'Sitemap Cache' do
          button_to 'Refresh', admin_dashboard_refresh_sitemap_path, method: :post, data: {
            confirm: 'Regenerate sitemap cache? It could take a while...'
          }
        end
      end

      column do
        panel 'Recent Reports' do
          ul do
            Report.todo.order(created_at: :desc).limit(5).map do |report|
              li do
                link_to("Report on \"#{report.game.title}\"", admin_report_path(report)) +
                  ' - ' +
                  link_to('Game Page', game_path(report.game), target: "_blank")
              end
            end
          end
        end
      end

      column do
        panel 'Games Under 15 Downloads' do
          ul do
            Game.where('downloads_count < ?', 15).where('games.created_at < ?', 30.days.ago).order(created_at: :desc).limit(5).map do |game|
              li link_to(game.title, game_path(game), target: "_blank")
            end
          end
        end
      end

      column do
        panel 'Recent Games' do
          ul do
            Game.order(created_at: :desc).limit(5).map do |game|
              li do
                link_to(game.title, admin_game_path(game)) +
                  ' - ' +
                  link_to('Game Page', game_path(game), target: "_blank")
              end
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Recent News' do
          ul do
            News.order(created_at: :desc).limit(5).map do |news|
              li do
                'There\'s a news on '.html_safe +
                  link_to(news.game.title, admin_game_path(news.game)) +
                  ' - ' +
                  link_to('Show', admin_news_path(news))
              end
            end
          end
        end
      end

      column do
        panel 'Recent Subscribers' do
          ul do
            Following.order(created_at: :desc).limit(5).map do |following|
              li do
                link_to(following.user.username, admin_user_path(following.user)) +
                  ' followed ' +
                  link_to(following.game.title, admin_game_path(following.game)) +
                  ' - ' +
                  link_to('Show', admin_following_path(following))
              end
            end
          end
        end
      end

      column do
        panel 'Recent Comments' do
          ul do
            Comment.order(created_at: :desc).limit(5).map do |comment|
              li do
                link_to(comment.user.username, admin_user_path(comment.user)) +
                  ' commented ' +
                  link_to(comment.game.title, admin_game_path(comment.game)) +
                  ' - ' +
                  link_to('Show', admin_comment_path(comment))
              end
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Monetisation Requests' do
          ul do
            Monetisation.where(approved: false).order(created_at: :desc).limit(5).map do |request|
              li do
                link_to(request.game.title, admin_game_path(request.game.id))
              end
            end
          end
        end
      end
    end
  end # content
end
