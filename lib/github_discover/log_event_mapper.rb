module GithubDiscover
  class LogEventMapper
    include Celluloid
    include Celluloid::Logger

    def initialize
      @log = File.open("tmp/debug.log", "a")
    end

    def map(event)
      @log.print(JSON.generate(event) + "\n")
    end
  end
end
