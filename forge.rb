$: << File.dirname(__FILE__)

require 'configuration'

require 'nil/file'

require 'Torrent'

if ARGV.size != 1
	puts 'Usage:'
	puts "ruby #{File.basename(__FILE__)} <input>"
	exit
end

inputPath = ARGV[0]
outputPath = Nil.joinPaths(Configuration::TorrentPath, File.basename(inputPath))
trackerPath = Configuration::TrackerFile

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
puts "Wrote data to #{outputPath}"
