require "zlib"

module GithubDiscover
  class ArchiveProcessor
    include Celluloid
    include Celluloid::Logger

    def process(path)
      puts "Start proc #{path}"
      Zlib::GzipReader.open(path) do |gzip|
        gzip.each_line do |line|
          #begin
            EventMapper.map!(JSON.parse(line))
          #rescue JSON::ParseError
            #MultiJsonParser.new(line) do |object|
              #EventMapper.map!(object)
            #end
          #end
        end
      end
      puts "End proc #{path}"

      nil
    ensure
      ActiveRecord::Base.clear_active_connections!
    end
  end
end
