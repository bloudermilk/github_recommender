module GithubDiscover
  class ArchiveDownloader
    include Celluloid#::IO
    include Celluloid::Logger

    URL_FORMAT = "http://data.githubarchive.org/%s.json.gz"
    TIME_FORMAT = "%Y-%m-%d-%-H"

    def get(time, io_out)
      url = URL_FORMAT % time.strftime(TIME_FORMAT)
      body = HTTP.get(url).body # , socket_class: Celluloid::IO::TCPSocket

      while chunk = body.readpartial
        io_out.print(chunk)
      end

      io_out.close
    end
  end
end
