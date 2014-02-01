require "open-uri"
require "fileutils"

module GithubDiscover
  class ArchiveDownloader
    include Celluloid
    include Celluloid::Logger

    FILE_FORMAT = "%Y-%m-%d-%-H.json.gz"
    URL_FORMAT = "http://data.githubarchive.org/#{FILE_FORMAT}"
    CACHE_DIR = File.expand_path("../../../tmp/githubarchive.org", __FILE__)
    CACHE_FORMAT = File.join(CACHE_DIR, FILE_FORMAT)

    def get(time, callback)
      cached = time.strftime(CACHE_FORMAT)

      unless File.exists?(cached)
        url = time.strftime(URL_FORMAT)

        open(url) do |tmp|
          FileUtils.mkdir_p(CACHE_DIR)
          File.open(cached, "w") { |f| f.write(tmp.read) }
        end
      end

      callback.call(cached)
    end
  end
end
