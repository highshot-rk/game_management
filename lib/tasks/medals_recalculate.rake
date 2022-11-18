# frozen_string_literal: true

namespace :medals do
  desc 'Recalculates medals'
  task :recalculate, %i[skip_notify full] => :environment do |_, args|
    ENV['SKIP_NOTIFICATIONS'] ||= 'medals.create' if args[:skip_notify].present?
    full = args[:full].present?

    Game.includes(:medals).find_each do |game|
      MedalsManager.new(game).refresh_medals(full)
    end

    User.where.not(confirmed_at: nil).includes(:medals, :game_medals).select(User.arel_table[Arel.star])
        .left_joins(:games).select(Game.arel_table[:id].count.as('games_count'))
        .group(:id)
        .find_each do |user|
      MedalsManager.new(nil, user).refresh_medals(full)
    end
  end
end
