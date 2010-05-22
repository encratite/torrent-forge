require 'nil/file'

require 'Torrent'

if ARGV.size != 2
	puts 'Usage:'
	puts "ruby #{File.basename(__FILE__)} <input> <output>"
	exit
end

input = Nil.readFile(ARGV[0])
output = ARGV[1]
torrent = Torrent.new(input)
