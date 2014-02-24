module GithubRecommender
  class Scraper < Celluloid::SupervisionGroup
    ONE_HOUR = 60 * 60

    pool ArchiveDownloader, as: :archive_downloader, size: pool_env("DL")
    pool ArchiveProcessor, as: :archive_processor, size: pool_env("PROC")

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

  def self.pool_env(name)
    name = "#{name}_POOL"

    ENV[name] ? ENV[name].to_i : 1
  end
end
