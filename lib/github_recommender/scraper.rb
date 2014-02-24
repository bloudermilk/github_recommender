module GithubRecommender
  class Scraper < Celluloid::SupervisionGroup
    ONE_HOUR = 60 * 60

    pool ArchiveDownloader, as: :archive_downloader, size: 2
    pool ArchiveProcessor, as: :archive_processor, size: 12

    def self.scrape!(start_at, end_at)
      run!

      cursor = start_at

      until cursor > end_at
        callback = proc do |path|
          Celluloid::Actor[:archive_processor].async.process(path)
        end

        Celluloid::Actor[:archive_downloader].async.get(cursor, callback)

        cursor += ONE_HOUR
      end

      sleep
    end
  end
end
