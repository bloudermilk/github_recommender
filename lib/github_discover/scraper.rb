module GithubDiscover
  class Scraper < Celluloid::SupervisionGroup
    include Celluloid

    ONE_HOUR = 60 * 60

    supervise ArchiveDownloader, as: :archive_downloader
    supervise GzipDecompressor, as: :gzip_decompressor
    supervise JsonStreamParser, as: :json_stream_parser

    # This would normally be EventMapper but I've been using LogEventMapper to
    # help measure performance (thanks `$ pv`)
    pool LogEventMapper, as: :event_mapper, size: 4

    def self.scrape!(start_at, end_at)
      run!

      cursor = start_at

      condition = Celluloid::Condition.new

      until cursor > end_at
        gzip_out, gzip_in = IO.pipe
        json_out, json_in = IO.pipe

        Celluloid::Actor[:archive_downloader].async.get(cursor, gzip_in)
        Celluloid::Actor[:gzip_decompressor].async.decompress(gzip_out, json_in)
        Celluloid::Actor[:json_stream_parser].async.parse(json_out, method(:on_event))

        cursor += ONE_HOUR
      end

      # TODO: Figure out how to wait for all jobs to be completed before exiting
      condition.wait
    end

    def self.on_event(event)
      Celluloid::Actor[:event_mapper].async.map(event)
    end
  end
end
