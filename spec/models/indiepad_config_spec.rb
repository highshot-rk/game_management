# == Schema Information
#
# Table name: indiepad_configs
#
#  id      :integer          not null, primary key
#  data    :json             not null
#  game_id :integer          not null
#
# Indexes
#
#  index_indiepad_configs_on_game_id  (game_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_de8e6fcffa  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe IndiepadConfig, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
