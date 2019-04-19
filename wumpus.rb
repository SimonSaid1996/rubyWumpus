#!/user/bin/env ruby
class Player
	
	def initialize( nam )
		@player_name = nam
		@cur_room_num =''	#originally set up as null, do it later
		@arrow_num = 4
	end

	def shoot_arrow()
		@arrow_num = @arrow_num - 1
	end	
	
	def have_arrow()
		if @arrow_num > 0
			return true 
		end
		return false	
	end

	def arrow_num()
		return @arrow_num
	end	
		
	def printName
		return @player_name
	end

	def	set_cur_rm(rm)
		@cur_room_num = rm
	end	

	def move_to( rm_num)
		@cur_room_num = rm_num
	end

	def get_cur_room
		return @cur_room_num
	end	
	
end

#code the monster movement next

class Room
	
	def initialize(num)		
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
	
	def get_nearby_rooms()
		return @nearby_room
	end	

	def set_ajacent_rooms( rm) 
		@nearby_room[ @null_room_num] = rm   #set the last index of the null room to this room
		@null_room_num = @null_room_num + 1  #increase the index of the null room
	end

	def get_nearby_rooms()
		return @nearby_room
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
			if @nearby_room[i].check_has_pit()
				puts "you feel a cold wind blowing from nearby cavern."      
				return true
			end	
		end
		return false	
	end

	def has_ajacent_hazard()	#if the nearby rooms have creatures
		for	i in 0..2 do
			if @nearby_room[i].check_has_hazard()
				puts "you smell something terrible nearby"
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
		@game_hint_index = -1
		puts "please input player name: "
		name = gets
		@my_player = Player.new( name)
		@meeting_bats = false
		@player_killed = false    #currently players can be killed by meeting wumpus or fallingto pit
		@wumpus_killed = false  
		@out_of_arrow = false	
		#initialize rooms with their ids
	end
	
	
	def connect_rooms()
		allrooms = Array(0..19)
		for i in 0..19 do
			for j in 0..19 do 		#loop 19 times to make sure every rooms are connected for 3 other rooms
				conroom = allrooms.sample
				unless @rooms[i].room_is_connected( @rooms[conroom] ) or @rooms[i].get_room_num() == @rooms[conroom].get_room_num() or @rooms[i].get_null_room_num > 2 or @rooms[ conroom ].get_null_room_num > 2	#if it is connected
					@rooms[i].set_ajacent_rooms( @rooms[conroom] )
					@rooms[conroom].set_ajacent_rooms( @rooms[i] )
				end	
					
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
			@rooms[ bat_room_num ].add_hazard("bat")    #batroomnum might have issues
			hazards_rooms.delete_at(hazards_rooms.index( bat_room_num) )
			pit_room_num = hazards_rooms.sample
			@pit_indexes[ i ] = pit_room_num #hazards_rooms[ pit_room_num ]
			@rooms[ pit_room_num ].add_pit()
			hazards_rooms.delete_at(hazards_rooms.index( pit_room_num) )
		end
		@wumpus_index = hazards_rooms.sample
		@rooms[ @wumpus_index ].add_hazard("wumpus")
		hazards_rooms.delete_at(hazards_rooms.index( @wumpus_index) )
		@game_hint_index = hazards_rooms.sample
		#allocate wumpus room and lucky god room	
	end	
	
	def find_start_room()   #find a safe room to start the game
		all_room_num = Array(0..19)
		
		for i in 0..2 do			
			all_room_num = all_room_num - [ @bats_indexes[ i ] ]
			all_room_num= all_room_num - [ @pit_indexes[ i ] ]
		end
		all_room_num = all_room_num - [ @wumpus_index ] 
		
		puts "#{@my_player.printName()} you start game at room, #{all_room_num[ 10 ]} "		#get a middle room, random value
		@my_player.set_cur_rm( @rooms[ all_room_num[ 10 ] ]) #set the room number
	end	

	def update_room(rm_num)
		@my_player.move_to( @rooms[ rm_num ])
	end	

	def shoot_room(rm_num)    #shotting an arrow at a room, judging if there is a wumpus in the room, if so, end the game, if not, continue
		if @my_player.have_arrow()
			
			if @wumpus_index == rm_num 
				puts "--------------------" #to separate lines
				puts "congrate, YOU HAVE KILLED THE WUMPUS！"
				@wumpus_killed = true
			else
				puts "------------\nsorry, no wumpus in the room."	
				puts "arrow num #{@my_player.arrow_num()}"
			end		
			@my_player.shoot_arrow()
		else
			@out_of_arrow = true
			puts "you have run out of arrows, u lose the game"	
		end
	end


	def bat_wumpus_change_places()
		puts "you have woken up the wumpus, now both wumpus and bats are moving to other rooms"
		available_rooms = Array(0..19)
		for i in 0..2 do		#get ride of the currently bats and pit rooms
			available_rooms = available_rooms - [ @pit_indexes[ i ] ]
			available_rooms = available_rooms - [ @bats_indexes[ i ] ]
		end	
		available_rooms = available_rooms - [ @wumpus_index ]
		new_wumpus_room = available_rooms.sample
		@wumpus_index = new_wumpus_room
		available_rooms.delete_at(available_rooms.index( new_wumpus_room) )
		new_bat_room = available_rooms.sample
		@bats_indexes[ 1 ] = new_bat_room

	end	

	def bat_moves_player()
		@meeting_bats = false #change the data back
		room_nm = rand(19)  #take player to any one of the rooms
		puts "bat is taking you to room, #{room_nm}"
		update_room(room_nm)
		#update the bat's location here, don't overlap with wumpus and pits
		bat_wumpus_change_places()
		near_rooms = @my_player.get_cur_room().get_nearby_rooms()
		puts "--------------\nnear rooms are, #{near_rooms[0].get_room_num}, #{near_rooms[1].get_room_num}, #{near_rooms[2].get_room_num} "
		check_cur_status()		#check the status again if taken by bats
	end	

	def meet_bats()  #check if the current location meets the bats, if so, print (later move player to other rooms)
		for i in 0..2 do
			if @rooms[ @bats_indexes[ i ] ] == @my_player.get_cur_room()
				@meeting_bats = true
				break
			end	
		end
		if @meeting_bats
			puts "meeting bats, curroom is ,#{@bats_indexes[ i ]}"
			bat_moves_player()
			return true
		end
		return false	
	end 

	def meet_pits()  #check if the current location meets the bats, if so, print (later move player to other rooms)
		for i in 0..2 do
			if @rooms[ @pit_indexes[ i ] ]== @my_player.get_cur_room()
				@player_killed = true
				break  
			end	
		end
		if @player_killed
			puts "---------\nstep on a pit,player killed, curroom is ,#{ @pit_indexes[ i ]}"
			return true
		end	
		return false
	end 

	def meet_wumpus()  #check if the current location meets the bats, if so, print (later move player to other rooms)
		if @rooms[ @wumpus_index ]== @my_player.get_cur_room()
			puts "---------\nmeeting wumpus,player killed curroom is ,#{@wumpus_index}"
			@player_killed = true
			return true
		end	
		return false
	end

	def meet_hint()
		if @rooms[ @game_hint_index ]== @my_player.get_cur_room()
			puts "---------\nyou met your lucky god, he told you that the wumpus is in room ,#{@wumpus_index}"
		end	
	end	

	def	check_cur_status()      #it should also tell people if it is next to wumpus or pit
		killed_by_pit = meet_pits()
		killed_by_wumpus = meet_wumpus()
		taken_by_bats = meet_bats()
		meet_hint()   #hint to tell the user where the wumpus is
		#game_hint_index  check if meeting the location of game hint, if so, tell the player where the wumpus is
		unless taken_by_bats  or killed_by_pit or killed_by_wumpus #if not taken by bats
			@my_player.get_cur_room().has_ajacent_hazard()
			@my_player.get_cur_room().has_ajacent_pit()		
		end
	end	

	def	player_is_killed()
		return @player_killed
	end
	
	def	wumpus_is_killed()
		return @wumpus_killed
	end	

	def get_player()
		return @my_player
	end	
 
	def have_no_arrows()
		return @out_of_arrow
	end	
end

def start_game()
	my_cave = Cave.new
	my_cave.connect_rooms()
	my_cave.allocate_hazards()
	my_cave.find_start_room()
	puts "--------\nhint:in the first round, u will not be notified any information about your neighbor rooms"
	until my_cave.player_is_killed() or my_cave.wumpus_is_killed() or my_cave.have_no_arrows()
		exit_rooms = my_cave.get_player().get_cur_room().get_nearby_rooms()
		print "Exits go to: #{ exit_rooms[0].get_room_num() }, #{ exit_rooms[1].get_room_num()}, #{ exit_rooms[2].get_room_num() }\n"
		#set an array of getroom numbers, forcing the use to choose rooms from here
		exit_rooms_num = Array[exit_rooms[0].get_room_num(), exit_rooms[1].get_room_num(), exit_rooms[2].get_room_num()]
		puts "-----------\nWhat do you want to do? (m)ove or (s)hoot?"
		action = gets.chomp	#need to check invalid input here
		puts "action is ,#{action} where do you want to shoot at or move to?"
		until action == "m" or action == "s"
			case action 
				when "m"
					puts "move to where?"
				when "s"
					puts "shoot at where?"
				else
					puts "invalid input, try again"
					action = gets.chomp
			end	
		end	
		action_num = take_action( my_cave.get_player(), exit_rooms_num)  #also need to check if the input is within the room choices
		player_change_state(action, action_num, my_cave.get_player(), my_cave) 
		unless my_cave.player_is_killed() or my_cave.wumpus_is_killed() or my_cave.have_no_arrows()
			puts "------------\nyou are now in room #{my_cave.get_player().get_cur_room().get_room_num()}"
			my_cave.check_cur_status()
		end
	end
	#sometimes, it will have some weird bugs and exit out weirdly 
end

def player_change_state(action, action_num, player, cave )		#depends on the states and room number, the player will goto the other rooms or other things happen
	if action == "m"	#move to other room
		cave.update_room( action_num )
	else	#shoot at the room
		cave.shoot_room( action_num )
	end	
end

def take_action( player, room_choice )
	input = gets.chomp   #now check if the input is int and if the selected room is within the neighbor choices
	until input.to_i.to_s == input and ( input.to_i== room_choice[0] or input.to_i== room_choice[1] or input.to_i== room_choice[2])
		if input.to_i.to_s == input and ( input.to_i== room_choice[0] or input.to_i== room_choice[1] or input.to_i== room_choice[2])
			puts "correct int input"
		else
			puts "invalid input, try again"
			input = gets.chomp
		end	
	end
	#need to check if the input rooms match any one of the three options
	input_num = input.to_i
	return input_num  #return input as an int
end	

if __FILE__ == $0
	start_game()
	
end