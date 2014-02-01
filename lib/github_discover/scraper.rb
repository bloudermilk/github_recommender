module GithubDiscover
  class Scraper < Celluloid::SupervisionGroup
    ONE_HOUR = 60 * 60

    supervise ArchiveDownloader, as: :archive_downloader
    supervise ArchiveProcessor, as: :archive_processor

    def self.scrape!(start_at, end_at)
      run!

      cursor = start_at

      condition = Celluloid::Condition.new

      until cursor > end_at
        Celluloid::Actor[:archive_downloader].async.get(cursor, method(:on_download))

        cursor += ONE_HOUR
      end

      # TODO: Figure out how to wait for all jobs to be completed before exiting
      condition.wait
    end

    def self.on_download(path)
      Celluloid::Actor[:archive_processor].async.process(path)
    end
  end
end
