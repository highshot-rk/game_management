# frozen_string_literal: true
RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].strategy = :transaction
  end

  config.before(:each, transactions: true) do
    DatabaseCleaner[:active_record].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].start
  end

  config.after(:each) do
    DatabaseCleaner[:active_record].clean
  end

  config.after(:all) do
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end

  config.before(:suite) do
    DatabaseCleaner[:redis].clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner[:redis].start
  end

  config.after(:each) do
    DatabaseCleaner[:redis].clean
  end

  config.after(:all) do
    DatabaseCleaner[:redis].clean_with(:truncation)
  end
end
