require "zlib"

module GithubDiscover
  class ArchiveParser
    def parse(path, &block)
      Zlib::GzipReader.open(path) do |gz|
        gz.each_line do |line|
          begin
            yield JSON.parse(line)
          rescue JSON::ParserError
            MultiJsonParser.new(line, &block).parse!
          end
        end
      end
    end
  end
end
