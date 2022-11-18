# frozen_string_literal: true
module GameFilters
  class ScoreFilter < ::ModelFilter
    def apply_filter(model)
      if param.present?
        model.joins(:scores)
              .group(:id)
              .select('games.*, max(scores.created_at) as screated_at')
      else
        model
      end
    end
  end
end
