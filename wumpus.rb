#!/user/bin/env ruby

class Room
	#attr_accessor :number
	creature = '' #means no bats and no wumpus currently
	has_pit = false #means originally no pit in the room
	
	def initialize(num)		#should be a loop to initialize the number of the rooms, also need 3 nearby rooms
		@room_number = num
	end
	
	def printRooms()
		@room_number
	end
	
	def set_ajacent_rooms(rm1, rm2, rm3)
		@nearby_room = Array.new(3)
	    nearby_room[0], nearby_room[1], nearby_room[2] = rm1, rm2, rm3
		#the above line might have issues
		#also need to check if all 3 nearby rooms are filled before adding new room connections
		
	end
	
end


class Player
	cur_room_num =''	#originally set up as null, do it later
	
	def initialize( nam )
		@player_name = nam
	end
	
	def printName
		@player_name
	end
	
end

class Cave
	
	def initialize()
		@rooms = Array.new(20)
		for i in 0..19 do @rooms[i] = Room.new(i) end
		#initialize rooms with their ids
	end
	
	
	def connect_rooms()
		@used_room_num = Array.new()
		#need a do while loop to generate the numbers
		new_rand = rand(20)
	
	
	end
	
	def printRooms
		for i in 0..19 do @rooms[i].printRooms  end
	
	end
end



if __FILE__ == $0
	puts "please input player name: "
	name = gets
	my_player = Player.new( name)
	my_cave = Cave.new
	#the method below can be used to connect the two way connections
	
	
=begin
    potential ways of adding connecting rooms
	a = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
    s = a.sample
	puts "range is, #{s}"
	a.delete_at(a.index(s))
	puts "the rest of range is , #{a}"	
=end
	#puts "myrooms are, #{my_cave.printRooms}"    #testing if the rooms are set up correctly
	#puts "playername, #{my_player.printName}"
	
	
end