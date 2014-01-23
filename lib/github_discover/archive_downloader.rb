module GithubDiscover
  class ArchiveDownloader
    include Celluloid
    include Celluloid::Logger

    URL_FORMAT = "http://data.githubarchive.org/%Y-%m-%d-%-H.json.gz"

    def get(time, io_out)
      debug "Starting to fetch #{time}"

      url = time.strftime(URL_FORMAT)

      HTTP.get(url).body.each do |chunk|
        debug "Got chunk of #{time}"
        io_out.print(chunk)
      end

      debug "Finished fetching #{time}"
    ensure
      io_out.close
    end
  end
end
