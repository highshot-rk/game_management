# == Schema Information
#
# Table name: auth_codes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  game_id    :integer
#  token      :string           not null
#  expires_at :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_auth_codes_on_game_id              (game_id)
#  index_auth_codes_on_token                (token) UNIQUE
#  index_auth_codes_on_user_id              (user_id)
#  index_auth_codes_on_user_id_and_game_id  (user_id,game_id)
#
# Foreign Keys
#
#  fk_rails_2460df48ce  (user_id => users.id)
#  fk_rails_29b7095c74  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe AuthCode, type: :model do
  always_has_a :game, Game.new
  always_has_a :user, User.new
  always_has_unique :token
end
