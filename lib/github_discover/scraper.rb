module GithubDiscover
  class Scraper < Celluloid::SupervisionGroup
    ONE_HOUR = 60 * 60

    class ArchiveRequester; end

    supervise ArchiveDownloader, as: :archive_downloader
    supervise GzipDecompressor, as: :gzip_decompressor

    def self.scrape!(start_at, end_at)
      run!

      gzip_out, gzip_in = ::IO.pipe
      json_out, json_in = ::IO.pipe

      Celluloid::Actor[:archive_downloader].async.get(start_at, gzip_in)
      Celluloid::Actor[:gzip_decompressor].async.decompress(gzip_out, json_in)

      json_out.each_line do |line|
        puts line
      end
    end
  end
end
