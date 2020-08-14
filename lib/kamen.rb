require "kamen/version"
require "kamen/control"
require "kamen/parser"
require "kamen/mock_cache"
require "kamen/middleware/mock_request"

# == Kamen Initialization
#
# When installed as a gem, you can activate the mock server on the following way:
#
# For Rails, add:
#   gem 'kamen'
# to your Gemfile
#
# Now ONLY Rails 3+ framework be supported.
#

if defined?(Rails::VERSION)
  if Rails::VERSION::MAJOR.to_i >= 3
    module Kamen
      class Railtie < Rails::Railtie

        initializer "kamen.mock_middleware", before: :load_config_initializers do |app|
          Kamen::Control.init_engine(app)
        end
      end
    end
  else
    warn "Your Rails version is too low, we recommend you to upgrade your framework"
  end
else
  warn "Kamen ONLY support Rails 3+ framework"
end

