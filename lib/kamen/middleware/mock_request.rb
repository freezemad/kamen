require 'action_dispatch'

module Kamen
  module Middleware
    class MockRequest
      def initialize app
        @app = app
      end

      def call env
        request = ActionDispatch::Request.new(env)
        # request.path  '/wechat_v1/orders/1
        _result = nil
        Rails.application.routes.router.recognize(request) do |route, params|
          # params => {:controller=>"wechat_v1/orders", :action=>"show", :id=>"1"}
          _filename = "#{Rails.root}/app/controllers/#{params[:controller]}_controller.rb"


          if File.exists?(_filename)
            _file =
              File.open(_filename, 'r')
            _started = false
            _finished = false
            _data = []
            _file.each_line do |line|
              if line.to_s =~ /def /
                if _data.blank?
                  next
                else
                  if line.to_s =~ /def #{params[:action]}/ # hit
                    _result = [200, {}, [_data.join]]
                    break
                  else #
                    _data = []
                    next
                  end
                end
              end
              if line.to_s =~ /MockData/
                if _started
                  _started = false
                else
                  _started = true
                end
                next
              end
              if _started
                _data << line.gsub(/^.*\#/,'')
              end
            end
            _file.close
          end

          return _result unless _result.blank?
        end

        @status, @headers, @response = @app.call(env)
        [@status, @headers, @response]
      end

    end
  end
end


