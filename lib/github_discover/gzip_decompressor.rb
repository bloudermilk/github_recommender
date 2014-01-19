require "zlib"

module GithubDiscover
  class GzipDecompressor
    include Celluloid
    include Celluloid::Logger

    def decompress(io_in, io_out)
      reader = Zlib::GzipReader.new(io_in)

      while chunk = reader.readpartial(1024)
        io_out.print(chunk)
      end
    rescue EOFError; ensure
      [io_in, io_out, reader].compact.each(&:close)
    end
  end
end
