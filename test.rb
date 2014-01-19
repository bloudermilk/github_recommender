require "zlib"

read, write = IO.pipe

thread_a = Thread.new do
  puts "About to start reader"
  reader = Zlib::GzipReader.new(read) # this blocks
  puts "Started reader"

  reader.each_byte do |line|
    puts "Yay byte!"
  end
end

file = File.open("tmp/githubarchive.org/2013-01-16-0.json.gz", "r")

puts "About to start reading"
file.each_byte do |chunk|
  puts "byte #{chunk}"
  write.puts(chunk)
end

puts "Done reading"

puts "closing write"
write.close

puts "closing file"
file.close

puts "joining thread"
#thread_a.join
