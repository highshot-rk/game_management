# == Schema Information
#
# Table name: monetisations
#
#  id                          :integer          not null, primary key
#  game_id                     :integer
#  paypal_account              :string
#  approved                    :boolean          default(FALSE)
#  description                 :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  prize_one_file_file_name    :string
#  prize_one_file_content_type :string
#  prize_one_file_file_size    :integer
#  prize_one_file_updated_at   :datetime
#  prize_two_file_file_name    :string
#  prize_two_file_content_type :string
#  prize_two_file_file_size    :integer
#  prize_two_file_updated_at   :datetime
#
# Indexes
#
#  index_monetisations_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_9e56cff301  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe Monetisation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
