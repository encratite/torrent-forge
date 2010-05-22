require 'nil/string'

class Torrent
	def initialize(input)
		@input = input
		@offset = 0
		@units = []
		processData
	end
	
	def processData
		while @offset < input.size
			
		end
	end
	
	def nextByte
		return @input[@offset]
	end
	
	def readUnit
		letter = nextByte
		case letter
		when 'i'
			#integer: i<digits>e
			@offset += 1
			offset = @input.index('e', @offset)
			raise 'Non-terminated integer' if offset == nil
			numberString = @input[@offset..(offset - 1)]
			raise "Invalid integer length: #{numberString}" if !numberString.isNumber
			number = numberString.to_i
			return number
		when 'l'
			output = []
			while true
				unit = readUnit
				return output if unit == nil
				output << unit
			end
		when 'd'
			output = {}
			while true
				key = readUnit
				return output if key == nil
				value = readUnit
				output[key] = value
			end
		when 'e'
			#terminator of dictionaries/lists
			return nil
		else
			if letter.isNumber
				#<length digits>:<content of legth specified by the previous field>
				offset = @input.index(':', @offset + 1)
				raise 'Non-terminated string' if offset == nil
				numberString = @input[@offset..(offset - 1)]
				raise "Invalid string length: #{numberString}" if !numberString.isNumber
				number = numberString.to_i
				@offset = offset + 1
				newOffset = @offset + number
				string = @input[@offset..(newOffset - 1)]
				@offset = newOffset
				return string
			else
				raise "Invalid unit type: #{letter}"
			end
		end
	end
end
