# frozen_string_literal: true

class NewLeaderJob < ApplicationJob
  include NotificationSender
  queue_as :default

  def perform(old_leader, game)
    leaders = game.scores.order(value: :desc).order(updated_at: :asc).limit(6).map(&:user)

    new_leader = leaders[0]

    # If leader remains the same
    return if old_leader == new_leader || new_leader.nil?

    other_leaders = leaders[2..-1] || []

    # New leader notification/email
    notify! new_leader, 'game_new_leader', from: new_leader, to: [new_leader], allow_self: true,
                                           params: { game_title: game.title }

    if old_leader
      # Ex leader notification/email
      notify! old_leader, 'game_old_leader', from: old_leader, to: [old_leader], allow_self: true,
                                             params: { leader: new_leader.username, game_title: game.title }
    end

    # Other leadears notification/email
    other_leaders.each do |leader|
      notify! leader, 'game_other_leader', from: leader, to: [leader], allow_self: true,
                                           params: { leader: new_leader.username, game_title: game.title }
    end

    # Game dev new leader notification/email
    notify!(game.user, 'game_dev_leader', from: game.user, to: [game.user], allow_self: true,
                                          params: { leader: new_leader.username, game_title: game.title }) unless leaders.include? game.user
  rescue StandardError => e
    raise e unless defined?(Raven)

    Raven.capture_exception(e)
  end
end
