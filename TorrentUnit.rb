class TorrentUnit
	attr_reader :description, :data
	
	def initialize(description, data)
		@description = description
		@data = data
	end
end
