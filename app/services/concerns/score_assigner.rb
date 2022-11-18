# frozen_string_literal: true
module ScoreAssigner
  extend ActiveSupport::Concern

  def assign_score(user, status)
    service = UserScoresService.new action: self.class.score_data[:name],
                                    status: status, user: user
    service.update
  end

  module ClassMethods
    def score(name)
      @score_data = { name: name }
    end

    def score_data
      @score_data
    end
  end
end
