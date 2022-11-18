# frozen_string_literal: true
module QueriesHelper
  extend ActiveSupport::Concern

  cattr_accessor :log_queries
  cattr_accessor :queries_count

  self.log_queries = false
  self.queries_count = 0

  included do
    ActiveSupport::Notifications.subscribe('sql.active_record') do |_event, start, finish, _id, data|
      if QueriesHelper.log_queries
        duration = (finish - start) * 1000
        puts "#{data[:sql]} (#{duration}ms)"
      end
      QueriesHelper.queries_count += 1
    end

    RSpec::Matchers.define :have_query_count do |expected|
      match do |actual|
        old_queries = QueriesHelper.queries_count
        actual.call
        @obtained = QueriesHelper.queries_count - old_queries
        @obtained == expected
      end

      failure_message do
        "Expecting to run #{expected} queries, #{@obtained} run instead."
      end

      supports_block_expectations
    end
  end

  def log_queries!
    QueriesHelper.log_queries = true
  end
end
