require 'kamen/middleware/mock_request'

module Kamen
  class Control
    def self.init_engine(config)
      config.middleware.insert_after(
        'ActionDispatch::RemoteIp',
        'Kamen::Middleware::MockRequest'
      )
    end
  end
end
