# guard :livereload do
#   watch(%r{app/views/.+\.(erb|haml|slim)})
#   watch(%r{app/helpers/.+\.rb})
#   watch(%r{public/.+\.(css|js|html)})
#   watch(%r{config/locales/.+\.yml})
#   # Rails Assets Pipeline
#   watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
# end

guard(:brakeman,
      run_on_start: true,
      min_confidence: 3,
      ignore_file: 'config/brakeman.ignore') do
  watch(%r{^app/.+\.(erb|haml|rhtml|rb)$})
  watch(%r{^config/.+\.rb$})
  watch(%r{^lib/.+\.rb$})
  watch('Gemfile')
end

guard(:consistency_fail,
      environment: 'development',
      run_on_start: true) do
  watch(%r{^app/model/(.+)\.rb})
  watch(%r{^db/migrations/(.+)\.rb})
  watch(%r{^db/schema.rb})
end

guard(:rspec,
      cmd: 'bin/rspec --color --format Fuubar',
      spec_paths: ['spec'],
      all_on_start: false,
      all_after_pass: false) do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { 'spec' }

  # Rails example
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/models/([^/]+)/(.+)\.rb$}) { |m| "spec/models/#{m[2]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| ["spec/requests/#{m[1]}_spec.rb", "spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }
  watch('config/routes.rb') { 'spec/routing' }
  watch('app/controllers/application_controller.rb') { 'spec/controllers' }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$}) { |m| "spec/features/#{m[1]}_spec.rb" }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
end

class Guard::Coverage < Guard::RSpec; end

guard(:coverage,
      cmd: 'COVERAGE=true bin/rspec --color --format Fuubar',
      cmd_additional_args: ' && open coverage/index.html',
      spec_paths: ['spec'],
      all_on_start: false,
      all_after_pass: false) do
end

guard :bundler_audit, run_on_start: true do
  watch('Gemfile.lock')
end
