require "zlib"

module GithubDiscover
  class GzipDecompressor
    include Celluloid
    include Celluloid::Logger

    def decompress(io_in, io_out)
      reader = Zlib::GzipReader.new(io_in)

      while chunk = reader.readpartial(4096)
        io_out.print(chunk)
      end

      [reader, io_out].compact.reject(&:closed?).each(&:close)
    end
  end
end
