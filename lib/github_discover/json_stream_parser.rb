module GithubDiscover
  class JsonStreamParser
    include Celluloid
    include Celluloid::Logger

    def parse(io_in, block)
      debug "Starting to parse some JSONs"

      while chunk = io_in.readline
        debug "Parsing a chunk of JSON"

        # I just met you
        # And this is crazy
        # But there's no streaming JSON parser for JRuby
        # So I used exceptions, baby
        begin
          block.call(JSON.parse(chunk))
        rescue JSON::ParserError
          MultiJsonParser.new(chunk, &block).parse!
        end
      end
    rescue EOFError
    ensure
      debug "Finished parsing some JSON"
      io_in.close
    end
  end
end
