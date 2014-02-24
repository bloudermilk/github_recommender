module GithubRecommender
  class Scraper < Celluloid::SupervisionGroup
    ONE_HOUR = 60 * 60

    def self.pool_env(actor, options = {})
      env = ENV["#{actor.name.underscore.upcase}_POOL"]
      size = env ? env.to_i : 1

      pool(actor, options.merge(size: size))
    end

    pool_env ArchiveDownloader, as: :archive_downloader
    pool_env ArchiveProcessor, as: :archive_processor

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
