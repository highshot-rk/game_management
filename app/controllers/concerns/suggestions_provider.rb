# frozen_string_literal: true
module SuggestionsProvider
  extend ActiveSupport::Concern

  def initialize_suggestions
    @suggested_games = Game.includes(self.class.games_suggestions_includes)
                           .suggested(send(self.class.games_suggestions_subject)).limit(2).decorate
    @random_games = Game.includes(@games_suggestions_includes).with_screens.random(4).order(created_at: :desc).decorate
  end

  module ClassMethods
    attr_reader :games_suggestions_includes
    attr_reader :games_suggestions_subject
    def suggestions(on: [], suggestion_subject: :game, includes: [:screen, :online_links])
      @games_suggestions_includes = includes
      @games_suggestions_subject = suggestion_subject
      before_action :initialize_suggestions, only: on
    end
  end
end
