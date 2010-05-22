require 'nil/file'

if ARGV.size != 2
	puts 'Usage:'
	puts "ruby #{File.basename(__FILE__)} <input> <output>"
	exit
end

