ENV["RAILS_ENV"] ||= 'test'

# Required modules
require 'rails/all'
require 'devise'
require 'devise/token_authenticatable'
require 'rspec/rails'
require 'timecop'
require 'pry'

# Required spec helper files
require 'support/rails_app/config/environment'
require 'support/helpers'
require 'support/integration'
require 'support/session_helper'

# factory_girl_rails has to be required after the test rails app
# as it sets the right application root path
require 'factory_girl_rails'

# Do not show migration output
ActiveRecord::Migration.verbose = false

# RSpec configuration
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.use_transactional_fixtures                       = true
  config.run_all_when_everything_filtered                 = true

  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #config.order = 'random'

  config.include FactoryGirl::Syntax::Methods

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    # Do initial migration
    ActiveRecord::Migrator.migrate(File.expand_path("support/rails_app/db/migrate/", File.dirname(__FILE__)))
  end
end
