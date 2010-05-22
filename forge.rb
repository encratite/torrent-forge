require 'nil/file'

require 'Torrent'

if ARGV.size != 2
	puts 'Usage:'
	puts "ruby #{File.basename(__FILE__)} <input> <output>"
	exit
end

inputPath = ARGV[0]
outputPath = ARGV[1]

input = Nil.readFile(inputPath)
torrent = Torrent.new(input)
output = torrent.getOutput
Nil.writeFile(outputPath, output)
