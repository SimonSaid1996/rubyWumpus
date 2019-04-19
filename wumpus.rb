#!/user/bin/env ruby
class Player
	cur_room_num =''	#originally set up as null, do it later
	
	def initialize( nam )
		@player_name = nam
	end
	
	def printName
		@player_name
	end

	def move_to( rm_num)
		cur_room_num = rm_num
		puts "you are in room, #{rm_num+1}"
	end
	
	def shoot_at( rm_num) #check if the wumpus is there, i guess it will be called in cave class
		#not sure how to implement yet
	end	
	
end

#code the monster movement next

class Room
	
	def initialize(num)		#should be a loop to initialize the number of the rooms, also need 3 nearby rooms
		@room_number = num
		@nearby_room = Array.new(3)
		@null_room_num = 0
		@has_pit = false
		@has_hazard = false
		@hazard_creature = ''

	end
	
	def get_room_num()
		return @room_number
	end
	
	#note that ruby's array will increase automatically, so u need to pay attention to the increasing array size

	def set_ajacent_rooms( rm) #should check which one is null, then add to that index
		@nearby_room[ @null_room_num] = rm   #set the last index of the null room to this room
		@null_room_num = @null_room_num + 1  #increase the index of the null room
		#puts "nullroomnum is, #{@null_room_num}"
	end

	def get_null_room_num
		return @null_room_num
	end

	#need a function to check if such a room is coonnected
	def room_is_connected( rm )
		for i in 0..2 do
			if @nearby_room[i] == rm
				return true 
			end	 
		end
		return false	
	end	
#not sure how to model if having hazard or not...
	def add_pit()
		@has_pit = true	
	end	

	def add_hazard( creature )	#add creature
		@has_hazard = true
		@hazard_creature = creature
	end	

	def remove_hazard()			#remove creature
		@has_hazard = false
		@hazard_creature = ''
	end	

	def check_has_pit()
		return @has_pit
	end
	
	def check_has_hazard()
		return @has_hazard
	end	

	def has_ajacent_pit() #if the nearby rooms have pits
		for	i in 0..2 do
			if @nearby_room[i].check_has_pit()   #not sure if it is correct
				return true
			end	
		end
		return false	
	end

	def has_ajacent_hazard()	#if the nearby rooms have creatures
		for	i in 0..2 do
			if @nearby_room[i].check_has_hazard()   #not sure if it is correct
				return true
			end	
		end
		return false	
	end	

end

class Cave
	
	def initialize()
		@rooms = Array.new(20)
		for i in 0..19 do @rooms[i] = Room.new(i) end
		@bats_indexes = Array.new(3)	#keep track of 3 bats
		@pit_indexes = Array.new(3)
		@wumpus_index = -1 			#to keep track where the wumpus is
		@start_room_index = -1
		puts "please input player name: "
		name = gets
		@my_player = Player.new( name)
		@fall_in_pitt = false
		@player_killed = false
		@wumpus_killed = false  	
		#initialize rooms with their ids
	end
	
	
	def connect_rooms()
		#@used_room_num = Array.new()
		#need a do while loop to generate the numbers
		allrooms = Array(0..19)
		for i in 0..19 do
			for j in 0..6 do 		#loop more than 3 times to make sure each room have 3 connections,can be more than 6 times
				conroom = allrooms.sample
				unless @rooms[i].room_is_connected( @rooms[conroom] ) or @rooms[i].get_room_num() == @rooms[conroom].get_room_num() or @rooms[i].get_null_room_num > 2 or @rooms[ conroom ].get_null_room_num > 2	#if it is connected
					#puts "connecting those two rooms, #{i}, #{conroom}"
					@rooms[i].set_ajacent_rooms( @rooms[conroom] )
					@rooms[conroom].set_ajacent_rooms( @rooms[i] )
				end	
				
				#allrooms.delete_at(allrooms.index(conroom))
				#puts "the rest of range is , #{allrooms}"	
			end
		end	
	end
	
	def printRooms
		for i in 0..19 do @rooms[i].printRooms  end
	end

	def allocate_hazards()		#a method to allocate all the bats, pits and wumpus
		hazards_rooms = Array(0..19)
		for i in 0..2 do		#allocate a bat and a pit each time
			bat_room_num = hazards_rooms.sample
			@bats_indexes[ i ] = bat_room_num #hazards_rooms[ bat_room_num]
			#puts "batroom is, #{bat_room_num}"
			@rooms[ bat_room_num ].add_hazard("bat")    #batroomnum might have issues
			hazards_rooms.delete_at(hazards_rooms.index( bat_room_num) )
			pit_room_num = hazards_rooms.sample
			@pit_indexes[ i ] = pit_room_num #hazards_rooms[ pit_room_num ]
			#puts "pitroom is , #{pit_room_num}"
			@rooms[ pit_room_num ].add_pit()
			hazards_rooms.delete_at(hazards_rooms.index( pit_room_num) )
		end
		@wumpus_index = hazards_rooms.sample
		@rooms[ @wumpus_index ].add_hazard("wumpus")
		#allocate wumpus room		
	end	
	
	def find_start_room()   #find a safe room to start the game
		all_room_num = Array(0..19)
		
		for i in 0..2 do			#everytimes u change the array,shouldn't use charAt to delete things
			#puts "deleting roomnum, #{@bats_indexes[ i ]},#{@pit_indexes[ i ]}"
			all_room_num = all_room_num - [ @bats_indexes[ i ] ]
			all_room_num= all_room_num - [ @pit_indexes[ i ] ]
		end
		all_room_num = all_room_num - [ @wumpus_index ] 
		
		puts "start game at room, #{all_room_num},#{all_room_num[ 10 ]} "
	end	

	def shoot_room(rm_num)

	end	


end



if __FILE__ == $0
	
	my_cave = Cave.new
	my_cave.connect_rooms()
	my_cave.allocate_hazards()
	 my_cave.find_start_room()
	#the method below can be used to connect the two way connections
	#puts "myrooms are, #{my_cave.printRooms}"    #testing if the rooms are set up correctly
	#puts "playername, #{my_player.printName}"
	
	#need a while loop here to guide the entire game, while not killing the wumpus or fall into pit

	
end