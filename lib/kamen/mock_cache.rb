module Kamen

  # Kamen will write mock data to file system, simultaneously cache them
  # in memory. It will be retrieved from cache when each request received.
  #
  # If cache hits, the data would be returned upstream. And if not, we will
  # find the source file and parse it. The parsed result would be persisted
  # and loaded in memory.
  #
  # Cache structure is Hash. The definition of key and value is as below.
  #
  # key: controller#action
  # value: [
  #   read,  # true|false, if already parsed
  #   data,  # mock data
  # ]
  #
  # There might be 3 cases for cache as below.
  # 1. Request mock exists but not in cache. It may be that no request ever come.
  #    Since our cache is lazyloaded, if no request is received, nothing would be cached.
  #
  # 2. Request mock exists in cache as value [true, {...}]. This is as we expected.
  #
  # 3. Request mock exists in cache as value [true, nil]. This means no mock data
  #    given by our Rais application. But we have already parsed the source. So next time
  #    the request would be passed directly to Rails application.
  module MockCache
    extend self

    @@mock_caches ||= {}
    @@mutex = Mutex.new

    # build a cache key
    def cache_key(params)
      controller = params.fetch(:controller, nil)
      action     = params.fetch(:action, nil)

      "#{controller}##{action}"
    end

    # Find mock response from cache.
    # return:
    # {
    #   read: true | false,
    #   data: mock
    # }
    def find_mock_response params
      key = cache_key(params)
      data = @@mock_caches[key] || [false, nil]

      Hash[[:read, :data].zip(data)]
    end

    # Write mock response to cache.
    def write_mock_response key, value
      @@mutex.synchronize do
        @@mock_caches[key] = [true, value]
      end
    end

  end
end
