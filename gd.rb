##############################################
#											
#   gd.rb --Main Code File for Global Destruction.		
#   (C) Copyright 1992, High Velocity Software, Inc.                                     
#   (C) Copyright 2002, Fly-By-Night Software (Ruby Version)                        
#                                                                                                            
############################################## 
$LOAD_PATH << "."

def random(r)
    # assume r is a range of integers first < last
    # this def by Mike Stok [mike@stok.co.uk] who deserves credit for it
    r.first + rand(r.last - r.first + (r.exclude_end? ? 0 : 1))
end



class GD_thread

require "gd_main.rb"
require "gd_messages.rb"
require "gd_cards.rb"
require "gd_const.rb"
require "gd_class.rb"
require "gd_score.rb"
require "gd_virtual.rb"

 include Enumerable
 
 	

 def initialize(users,who,channel,log,c_num)
       reset
     #  set_up_database

       @who 		= who
       @users 		= users
			 @channel 		= channel
			 @log			= log
			 @c_num		= c_num      
      
       @comp_num	= 0				#Number of Computer Players
       @started		= false
       @deck		= Deck.new		
       
       @output = []
       @startnic = ""
       @v_players = Players.new
       @v_countries = []
       @deck.setitup
       
       @scores = Scores.new
       @scores.loadscores

       @randoms = []
       @randoms.push(Special.new(RANDTHUNDERBOLT,6,false))
       @randoms.push(Special.new(RANDTHUNDERBOLT,3,true))
       @randoms.push(Special.new(RANDPOPDEATH,12,true))
       @randoms.push(Special.new(RANDPOPDEATH,8,false))
       @randoms.push(Special.new(RANDLOSETURN,4,false))
       @randoms.push(Special.new(RANDAEGIS,6,false))
       @randoms.push(Special.new(RANDAEGIS,3,true))
 end

def reset
       #@comp_num	= 0				#Number of Computer Players
       @players		= Players.new
       @usd_country	= [] 				#Countries that have been used.
       @war			= false 			#Does a state of war exist?
       @turn			= 0				#Who's turn is it? 
       @turns_to_peace	= 0
       @complete		= false			#Turn complete?
       @turn_type		= INPUT_NORMAL	#What type of input are we getting?
       @card_in_play	= NO_CARD		#The last card played by the current player.
       @abm_in_play	= 0				# The *missile* being processed by incomming
       @spy_mode		= 0
       @incomming_lock	= false			# Has the User been in Incomming this turn?
       @current_time     = Time.now.to_i
       @turn_time         = 0
       @warned            = false

end


 	def blat(line) 
			j = 0
			for j in 0..@channel[@c_num].usrchannel.length - 1 
				@users[@channel[@c_num].usrchannel[j]].page.push(line) 
			end
		end

		def blat_anti (user,line)
			j = 0
			for j in 0..@channel[@c_num].usrchannel.length - 1 
				@users[@channel[@c_num].usrchannel[j]].page.push(line) if @users[@channel[@c_num].usrchannel[j]].name != user
			end
		end

		def blat_anti2 (user,user2,line)
			j = 0
			for j in 0..@channel[@c_num].usrchannel.length - 1 
				@users[@channel[@c_num].usrchannel[j]].page.push(line) if @users[@channel[@c_num].usrchannel[j]].name != user and @users[@channel[@c_num].usrchannel[j]].name != user2
			end
		end


		def blat_usr(user,line)

			j = 0 
			doit = false
			for j in 0..@channel[@c_num].usrchannel.length - 1
				doit = true if @channel[@c_num].usrchannel[j] == user		#we want to make sure we don't page a virtual user.. because they aren't real...
			end
			@users[user].page.push(line) if doit
		end
 
 
 def remove_user (disc_user)
 # puts "removing user #{disc_user}"
  @players[disc_user].dead = true
  #puts "@players[disc_user]: #{@players[disc_user]}"
  #puts "@turn: #{@turn}"
   if @players[disc_user].name == @players[@turn].name
    puts "Trying To End Turn Of: #{@players[disc_user].name}"
    @complete = true  
    do_tick  # so we loop and go to the next turn
   end
    
 end
 
 def run
 

  startup = false
  puts "-Starting GD thread for channel: #{@c_num}"
  puts "-Adding virtual players for channel: #{@c_num}"
  
  #v_add(2)
  v_create_list(2)
  loop do
   do_tick 
  sleep(0.1)
  # puts "GDthread: #{@started}"
    
    #waiting to start the game loop...
    if !@started then 
     @channel[@c_num].g_buffer.each {|x| 
     parray 	= Array.new
		 puts "x: #{x}"
		 puts "x.split: #{x.split.each {|x| put x}}"
     parray	= x.split
		         puts "DEBUG: players.length: #{@players.len}"
				puts "DEBUG: parray: #{parray.length}"
					puts "DEBUG: parray: #{parray.each {|x| puts x}}"	
     if parray.length > 1 then
      if parray[1].upcase == "START"  and !@started then
        sleep(1)
         puts "DEBUG: -resetting game"
        reset 
        #v_add(2)
        puts "DEBUG: vplayers.length: #{@v_players.len}"
        v_combine
        puts "DEBUG: players.length: #{@players.len}"
				puts "DEBUG: parray: #{parray.length}"
					puts "DEBUG: parray: #{parray.each_with_index {|x,i| puts i,x}}"			
        startit(parray[0])
       @channel[@c_num].status = true
       
      
       
       puts "-Starting GD Game"
      end
     end
     
   }
		@channel[@c_num].g_buffer.clear  
  end 
  
  
  
  
   current_time = Time.now.to_i
   
   if @started then
     @players.each {|x|
      puts x.name}
    if (current_time - @turn_time > TIME_WARN) and !@warned and !@players[@turn].dead then
    m_warning(@players[@turn].name)
    @warned = true
    end

   
    if (current_time - @turn_time > TIME_LIMIT) and (!@players[@turn].dead) and (!@players[@turn].virtural) then
     m_kickoff_user(@players[@turn].name)
     m_kickoff(@players[@turn].name,@players[@turn].country)
     remove_user (@players[@turn].name)
    end

  
    @channel[@c_num].g_buffer.each {|x| 
    parsecmd(x)
   }
		@channel[@c_num].g_buffer.clear  

  end
end
end
 
end

