# frozen_string_literal: true
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

class AuthCode < ApplicationRecord
  belongs_to :user
  belongs_to :game

  before_validation do
    self.expires_at ||= 1.month.from_now
    self.token ||= SecureRandom.urlsafe_base64(32)
  end

  scope :expired, -> { where('expires_at < ?', Time.zone.now) }
  scope :valid, -> { where('expires_at >= ?', Time.zone.now) }

  def expired?
    expires_at < Time.zone.now
  end

  validates :user, :game, presence: true
  validates :token, :expires_at, presence: true
  validates :token, uniqueness: true
end
