require "zlib"

module GithubRecommender
  class ArchiveProcessor
    include Celluloid
    include Celluloid::Logger

    def process(path)
      Zlib::GzipReader.open(path) do |gzip|
        gzip.each_line do |line|
          parse_line(line) do |event|
            EventMapper.map!(event) rescue log_error($!, event: event)
          end
        end
      end

      debug "Finished processing #{path}"
    ensure
      ActiveRecord::Base.clear_active_connections!
    end

    def parse_line(line, &block)
      yield JSON.parse(line)
    rescue JSON::ParserError
      parse_multiline(line, &block)
    rescue => error
      log_error(error, line: line)
    end

    def parse_multiline(line, &block)
      MultiJsonParser.new(line, &block) rescue log_error($!, line: line)
    end

    def log_error(error, meta = {})
      $stderr.puts JSON.generate({
        class: error.class.to_s,
        message: error.message,
        backtrace: error.backtrace,
        meta: meta,
      })
    end
  end
end
