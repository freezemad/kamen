module Kamen
  # =begin/=end is temporarily not supported
  module Parser
    extend self

    TOKENIZER = "MockData"

    # tokenizer of mock data comment block
    def mock_tokenizer
      @@mock_tokenizer ||= Regexp.new(/^[[:blank:]]*\#.*#{TOKENIZER}/)
    end

    # build source file fullpath
    def find_source_file params
      source_dir = File.expand_path(File.join(Rails.root, 'app','controllers'))
      basename = "#{params[:controller]}_controller.rb"

      File.join(source_dir, basename)
    end

    # Read source and parse.
    # Kamen will mark that the source is already handled unless you modify the source.
    # So if no mock given, we will pass request to your rails application the next request directly.
    # This will avoid to do some logic repeatly.
    #
    # return:
    #   true | false , if there is some data written in cache.
    def handle_source_file params
      filepath = find_source_file(params)

      return false unless File.exists?(filepath)

      file = File.open(filepath, 'r')

      _started = false
      _data = []
      _return_val = false

      file.each_line do |line|
        if mch = /^[[:blank:]]*def ([a-z0-9_]+)/.match(line)
          if _data.blank? # current method has no mock data
            next
          else
            if mch[1] == params[:action]  # hit
              key = MockCache.cache_key(params)
              MockCache.write_mock_response(key, _data.join)
              _return_val = true
            else # miss, but there exists a mock
              key = MockCache.cache_key(controller: params[:controller],
                                           action: mch[1])
              MockCache.write_mock_response(key, _data.join)
            end
            _data = []
            next
          end
        end

        if line =~ mock_tokenizer
          _started = !_started
          next
        end
        if _started
          _data << line.gsub(/^[[:blank:]]*\#/, "")
        end
      end
      file.close
      _return_val
    end

  end
end
