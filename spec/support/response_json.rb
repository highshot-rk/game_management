# frozen_string_literal: true
ActionDispatch::TestResponse.send(:define_method, :json) do
  JSON.parse(body)
end
