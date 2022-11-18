# frozen_string_literal: true
ActiveAdmin.register_page 'Backups' do
  menu priority: 2, label: proc { 'Backups' }

  page_action :make_backup, method: :post do
  end

  content title: proc { 'Backups' } do
    # Here is an example of a simple dashboard with columns and panels.
    #

    columns do
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
  end # content
end
