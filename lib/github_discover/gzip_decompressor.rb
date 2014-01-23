require "zlib"

module GithubDiscover
  class GzipDecompressor
    include Celluloid
    include Celluloid::Logger

    def decompress(io_in, io_out)
      debug "Starting to decompress something"

      reader = Zlib::GzipReader.new(io_in)

      debug "Started decompressing something"

      while chunk = reader.readpartial(4096)
        debug "Decompressed a chunk of something"
        io_out.print(chunk)
      end

      debug "Finished decompressing something"
    ensure
      # Closing `reader` also closes `io_in` but `reader` can be nil
      [reader, io_in, io_out].compact.each { |io| io.close unless io.closed? }
    end
  end
end
