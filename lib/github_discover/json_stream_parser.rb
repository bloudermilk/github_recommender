module GithubDiscover
  class JsonStreamParser
    include Celluloid
    include Celluloid::Logger

    def parse(io_in, block)
      while chunk = io_in.readline
        begin
          block.call(JSON.parse(chunk))
        rescue JSON::ParserError
          builder = MultiJsonParser.new(chunk, &block)
        end
      end
    rescue EOFError; ensure
      io_in.close
    end
  end
end
