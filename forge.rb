require 'nil/file'

require 'Torrent'

if ARGV.size != 3
	puts 'Usage:'
	puts "ruby #{File.basename(__FILE__)} <input> <output> <new trackers>"
	exit
end

inputPath = ARGV[0]
outputPath = ARGV[1]
trackerPath = ARGV[2]

input = Nil.readFile(inputPath)
if input == nil
	puts "Failed to read torrent file #{inputPath}"
	exit
end
torrent = Torrent.new(input)

trackers = Nil.readLines(trackerPath)
if trackers == nil
	puts "Failed to read tracker file #{trackerPath}"
end

if trackers.empty?
	puts 'Error: The list of trackers you have specified is empty!'
	exit
end

root = torrent.units[0]
root['announce'] = trackers[0]
root['announce-list'] = trackers.map{|x| [x]}

output = torrent.getOutput
Nil.writeFile(outputPath, output)
