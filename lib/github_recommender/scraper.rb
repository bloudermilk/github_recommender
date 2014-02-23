module GithubRecommender
  class Scraper < Celluloid::SupervisionGroup
    ONE_HOUR = 60 * 60

    supervise ArchiveDownloader, as: :archive_downloader
    supervise ArchiveProcessor, as: :archive_processor

    def self.scrape!(start_at, end_at)
      run!

      futures = []
      cursor = start_at

      until cursor > end_at
        callback = proc do |path|
          futures << Celluloid::Actor[:archive_processor].future.process(path)
        end

        Celluloid::Actor[:archive_downloader].async.get(cursor, callback)

        cursor += ONE_HOUR
      end

      futures.each(&:value)
    end
  end
end
