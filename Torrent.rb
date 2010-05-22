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
			unit = readunit
			@units << unit
		end
	end
	
	def nextByte
		return nil if @offset >= @input.size
		return @input[@offset]
	end
	
	def readUnit
		letter = nextByte
		case letter
		when 'i'
			return readInteger
		when 'l'
			return readList
		when 'd'
			return readDictionary
		when 'e'
			#terminator of dictionaries/lists
			return nil
		when nil
			raise 'Incomplete list/dictionary'
		else
			if letter.isNumber
				return readString
			else
				raise "Invalid unit type: #{letter}"
			end
		end
	end
	
	def readInteger
		#integer: i<digits>e
		@offset += 1
		offset = @input.index('e', @offset)
		raise 'Non-terminated integer' if offset == nil
		numberString = @input[@offset..(offset - 1)]
		raise "Invalid integer length: #{numberString}" if !numberString.isNumber
		number = numberString.to_i
		return number
	end
	
	def readList
		output = []
		while true
			unit = readUnit
			return output if unit == nil
			output << unit
		end
	end
	
	def readDictionary
		output = {}
		while true
			key = readUnit
			return output if key == nil
			value = readUnit
			output[key] = value
		end
	end
	
	def readString
		#<length digits>:<content of legth specified by the previous field>
		offset = @input.index(':', @offset + 1)
		raise 'Non-terminated string' if offset == nil
		numberString = @input[@offset..(offset - 1)]
		raise "Invalid string length: #{numberString}" if !numberString.isNumber
		number = numberString.to_i
		@offset = offset + 1
		newOffset = @offset + number
		raise "Invalid string length: #{number}" if newOffset >= @input.size
		string = @input[@offset..(newOffset - 1)]
		@offset = newOffset
		return string
	end
end
