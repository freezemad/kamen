require 'action_dispatch'

module Kamen
  # middleware
  module Middleware
    class MockRequest
      def initialize app
        @app = app
      end

      def call env
        request = ActionDispatch::Request.new(env)

        Rails.application.routes.router.recognize(request) do |route, params|
          # params => {:controller=>"v1/users", :action=>"show", :id=>"1"}

          resp = ::Kamen::MockCache.find_mock_response(params)
          if resp[:read]  # source file is parsed
            unless resp[:data].nil? # cache hits, there is a mock data
              return [200, {}, [resp[:data]]]
            else # no mock data given, pass request to rails application
              # just skip this branch and exit block to call downstream middleware
            end
          else

            if ::Kamen::Parser.handle_source_file(params)

              # there is some data written in cache so we can load again.
              resp = ::Kamen::MockCache.find_mock_response(params)

              return [200, {}, [resp[:data]]] if resp[:read] && resp[:data]
            end
          end
        end

        @status, @headers, @response = @app.call(env)
        [@status, @headers, @response]
      end

    end
  end
end


