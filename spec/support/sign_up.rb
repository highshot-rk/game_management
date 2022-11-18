# frozen_string_literal: true
def sign_up(options = {})
  Warden.test_mode!
  user = create(:user, options)
  login_as(user, scope: :user)
  user
end
