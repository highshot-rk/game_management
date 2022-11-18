# == Schema Information
#
# Table name: supporters
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  game_id    :integer
#  prize      :integer
#  confirmed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_supporters_on_game_id  (game_id)
#  index_supporters_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_20f2c914c7  (user_id => users.id)
#  fk_rails_948a882449  (game_id => games.id)
#

class Supporter < ApplicationRecord
  belongs_to :user
  belongs_to :game

  include PublicActivity::Common
end
