# frozen_string_literal: true
module RSpec
  module Sidekiq
    module Matchers
      # rubocop:disable Style/PredicateName
      def have_enqueued_sidekiq_job(*expected_arguments)
        # rubocop:enable Style/PredicateName
        HaveEnqueuedSidekiqJob.new expected_arguments
      end

      HaveEnqueuedSidekiqJob = HaveEnqueuedJob
    end
  end
end
