require 'messagestrings.rb'
require 'tools.rb'

class Session

	def listactions
		actions = ["AFK","AGREE","APOL","BACK","BDAY","BLUSH","BOW","BRB",
		"CHEER","CHORTLE","DANCE","DRINK","LAUGH","TOKE","WAVE"]
		i = 0
		cycle = ["%G","%C","%Y","%M","%B"]

		if actions.empty?
			print "%Y-- %RNo Actions Defined %Y--" 
			return
		end

		print;
		print "%GActions"
		print "%W-------"

		actions.each {|x|
			write(cycle[i])
			write x.ljust(15)
			i = i.succ % 5
			print if i == 0
		}
		print
	end


	
	def channelexists?(chan)
    puts chan-1
    puts "@channel.has_index?(chan-1): #{@channel.has_index?(chan-1)}"
    puts "@channel[chan-1]): #{@channel[chan-1]}"

    if chan-1 <= @channel.len and chan > 0 then
		@channel[chan-1] and !@channel[chan-1].deleted 
    else return false end
	end


	def checkpswd(chnum)
    return true if @channel[chnum].password == ""
		prompt = "Password: " 
		password =  getinp(prompt).upcase.strip
		if @channel[chnum].password == password then 
			return true
		else 
			print "%RIncorrect Password.  You need a password for this table.\r\n"
			return false
		end
	end

 def active_player (name)  
  
   for i in 0..@channel[@users[@c_user].channel].players.length - 1
   puts "@channel[@users[@c_user].channel].players[i].upcase #{@channel[@users[@c_user].channel].players[i].upcase}"
   puts "name.upcase: #{name.upcase}"
   puts "@channel[@users[@c_user].channel].status: #{@channel[@users[@c_user].channel].status}"
    if @channel[@users[@c_user].channel].players[i].upcase == name.upcase and @channel[@users[@c_user].channel].status
      print "%Y--%R You can't leave the channel while you are playing. %Y--"
     return false 
    end
   end
  return true
end

	def changechannel(parameters)
		listchannels if parameters[0] > -1

		prompt = "%WTable #[#{@users[@c_user].channel+1}] (1-#{@channel.len}) ? for list, <CR> to quit: " 
		getinp(prompt) {|c|
			h = c.upcase.strip
			chan = h.to_i
			case h
			when ""; true
			when "CR"; crerror; false
			when "?"; listchannels; false
			else; _changechannel(chan); true
			end
		}
	end

	def _changechannel(newchan)
		if !channelexists?(newchan)
			print "No such table: #{newchan}"
			return false
		end

		return false unless ((@channel[newchan-1].password == "") or (@users[@c_user].level >= TELESYSOPLEVEL))
		return false unless checkpswd(newchan-1)
    return false unless active_player(@users[@c_user].name)

		# leave old channel
		chan = @channel[@users[@c_user].channel]
		chan.usrchannel.delete(@c_user)
		chan.line = "%M#{@c_user} %Yhas moved to another table."
		chan.from = nil
		chan.count -= 1

		#join new channel
		chan = @channel[@users[@c_user].channel = newchan-1]
		chan.usrchannel.push(@c_user)
		print "%Y-- %GMoving to the #{chan.name} table %Y--\r\n"
		chan.line = "%M#{@c_user} %Ysits down at the table."
		chan.from = nil
		chan.count += 1
	end

	def listchannels
		x = 0
		if @channel.empty? then
			print NOCHANNELSERROR
			return false
		end

		a = <<-here
		%GCurrent Tables:

		%Y#   %GTable*          %MStatus
		here
		print a.gsub('*') {' '*10}
		@channel.each_with_index {|chan, x|
			if !chan.deleted then
				write "%Y#{(x+1).to_s.ljust(4)}"
				write "%G#{chan.name.fit(25)}"
        x = "Game Running" 
        x = "Game Stopped" if !chan.status
				write "%M#{x}\r\n"
			end
		}
		print 
	end

	def parseaction (inline)
		actions = ["AFK","AGREE","APOL","BACK","BDAY","BLUSH","BOW","BRB","CHEER","CHORTLE","DANCE","DRINK","LAUGH","TOKE","WAVE"]
		lactions = ["Don't be gone long...","That's right!","On my hands and knees.","You're back, eh?","Happy Birthday!",
		"My what a lovely shade of red!","You bow so nicely.","Hurry back!","Hip, Hip, Hooray!","You chortle evilly!",
		"Do the hustle!","Pick your poison.","Hah Hah Hah","Smoke Up, Dude!","Aloha!"]
		tactions = ["is away from his keyboard","agrees with you whole-heartedly!","offers you his humblest apology.","is back!",
		"wishes you a happy BIRTHDAY!","turns away from you and blushes.","bows to you respectfully.",
		"will be right back.","is cheering for you enthusiastically!","is chortiling at you evilly!",
		"grabs you and dances around the room!","offers to buy you a drink","is laughing at you.","hands you a pipe.","waves at you!"]
		aactions = ["is away from his keyboard","agrees with # whole-heartedly!","offers # his humblest apology.","is back!",
		"wishes # a happy BIRTHDAY!","turns away from # and blushes.","bows to # respectfully.","will be right back.",
		"is cheering for # enthusiastically!","is chortiling at # evilly!","grabs # and dances around the room!",
		"offers to buy # a drink","is laughing at #","offers # a pipe","waves at #!"]
		uactions= ["is away from his keyboard","is in agreement...","apologizes to everyone","is back!",
		"says today is his BIRTHDAY","is blushing a lovely shade of red.","bows respectfully to everyone.",
		"will be right back","is cheering for everyone!","chortles evilly!","puts on his dancing shoes.",
		"offers to buy everyone in the room a drink.","is laughing his ass off.","sparks a bowl","waves at everyone."]

		parray = inline.split
		directed = false

		return false if parray.empty?

		command = parray[0].upcase
		i = actions.index(command)
		return false if i == nil

		if parray.length > 1 then
			parray.delete_at(0)
			user = parray.join(" ")
			directed = true
		end

		output1 = "%M#{@c_user} %Y#{uactions[i]}"

		chan = @channel[@users[@c_user].channel]

		if directed then 
			to = whois(parray[0])
			if !to then 
				print "no such user #{parray[0]}"
				return false
			end
			print "%Y#{lactions[i]}"
			(@users[@users.findalais(to).name].page ||= []).push("%M#{@users[@c_user].alais} %Y#{tactions[i]}")
			chan.usrchannel.each {|u|
				output2 = aactions[i].gsub("#",to)
				@users[u].page.push("%M#{@users[@c_user].alais} %Y#{output2}") if ![to.upcase, @c_user].include?(u)
			}	
		else # if not directed
			print "%Y#{lactions[i]}"
			chan.line = output1
			chan.from = nil
			chan.count += 1
		end
		return true
	end




	def globallist
		@channel.each_index {|i| whoinchannel(i) if !@channel[i].deleted}
	end

	def whoinchannel(channelnum,header)
		i = 0
    list = []
    
    if header then
		 print "%GPlayers at #{@channel[channelnum].name}:%M\r\n "
   end
   
		chan = @channel[channelnum]

		if !chan.usrchannel.empty? then

			chan.usrchannel.each {|x| 
        if !header then
         list.push(x)  if x.upcase != @users[@c_user].alais.upcase
        else
          list.push(x)
        end
			 }
		end

		if !chan.v_usrchannel.empty? then
			chan.v_usrchannel.each {|x| 
				list.push(x)
			}
		end
    
    for i in 0..list.length-1
     write list[i]
     if i < (list.length - 2) then
      write ", "
    end
    if i == (list.length - 2) then
      write " %Gand%C "
    end 
  end
    write "%G."
		print; print 
	end 



	def gd_header
  
		print "%GWelcome to... %RGlobal Destruction%W!\r\n"
		print "%GIf you haven't already read the introduction to the game, we suggest"
		print "that you peruse that to get familiar with the game.  To do that, enter"
		print "%WHELP INTRO%G at the next prompt and press <Enter>\r\n"
		print "Remember, when playing the game, you can always type %WHELP%G"
    print  "(%Wor a ?%G) for help!  May the best dictator win...\r\n"
    write "%GYou are sitting at %C#{@channel[@users[@c_user].channel].name}%G with %C" 
    whoinchannel(@users[@c_user].channel,false)

	end

	def _whois(instr, v)
		resultlst = []

		chan = @channel[@users[@c_user].channel]
    if instr.nil? then
      print "%RTo direct a message, you must supply a user."
      return (nil)
    end
    
		c = v ? chan.v_usrchannel : chan.usrchannel
		c.each {|name|
			x = (@users[name].alais.upcase =~ Regexp.new(instr.upcase))
			resultlst.push(@users[name].alais) if  x != nil
		}

		l = resultlst.length
		return (
			case
			when l < 1; nil
			when l == 1; resultlst[0]
			when l > 1; print "%RUnable to determine user.  Be more specific."; nil
			end
		)
	end

 
   
   
	def whois(instr)
		_whois(instr, false)
	end

	def whois_v(instr)
		_whois(instr, true)
	end

	def teleconference
    #move this to the startup of the game

		@chatbuff.clear
		checkuseralias
		gd_header
		chan = @channel[@users[@c_user].channel]
		@channel[@users[@c_user].channel].usrchannel.push(@c_user)
		@channel[@users[@c_user].channel].line = "%M#{@users[@c_user].alais} %Ghas entered the teleconference"
		@channel[@users[@c_user].channel].from = nil
		@channel[@users[@c_user].channel].count += 1
		#displaycolors if @users[@c_user].ansi 

		directed = ""
		prompt = "%C#{@users[@c_user].channel+1}: "
		getinp_c(prompt) {|l|
      puts "@channel[@users[@c_user].channel].players.length: #{@channel[@users[@c_user].channel].players.length}"
      @channel[@users[@c_user].channel].players.each {|x| puts x}
      slashquit = false
      msgsent = true
			line = l.strip
      cmds = line.split
			@channel[@users[@c_user].channel].g_buffer.push("#{@users[@c_user].alais} #{line}") 
      msgsent = displayhelp(cmds)
      action = parseaction(line)
       
			if !action then
				happy = line.dup
				parameters = Parse.parse(happy)
				happy.gsub!(/[-\d]/,"")

        msgsent = gamecommand(cmds, parameters)
        
				if happy == "?" 
					gfileout("chatmnu")
				else 
          

          if msgsent and !cmds.empty? then
					 insert, line, msgsent, slashquit = slashcommand(happy, parameters)
           
          if  chan.status and msgsent then #is the game running, is it a game command?  if so, don't echo....
            msgsent = !(%w(STAT NIFTY TABLE STOCK DEFENSE DEFENCE HIGH SCORE SURRENDER TURN PASS USE INCOMING).include?(cmds[0].upcase))
          end
     
        # is the game running, and the current user in a locked state (answering a game prompt)     
        if  !@channel[@users[@c_user].channel].a_player.nil? 
     
         if chan.status and msgsent and (@channel[@users[@c_user].channel].a_player.upcase == @users[@c_user].alais.upcase) and (@channel[@users[@c_user].channel].locked) then
           msgsent = false 
           puts "input locked"
         end
       end
       
					 if (line != '') and (msgsent) then
						print "%Y--%G#{insert} Message Sent%Y --%G"
						@channel[@users[@c_user].channel].line = line
						@channel[@users[@c_user].channel].from = @users[@c_user].alais
						@channel[@users[@c_user].channel].count += 1
					end
          
        end
				end
				@chatbuff.each {|x| print x}
				@chatbuff.clear
			end
			slashquit
		}
	end

  def gamecommand(cmds, parameters)
      if !cmds.empty? then
        if !cmds[0].nil? then
         msgsent = !(%w(join scan).include?(cmds[0].downcase))
    
			case cmds[0].upcase
        when "JOIN"; changechannel(parameters)
        when "SCAN"; listchannels
        when "ACTIONS"; listactions
      end
    end
  end
  return msgsent
end
  
	def slashcommand(happy, parameters)
		chan = @channel[@users[@c_user].channel]
    line = happy.dup
		q = false
    msgsent = true

    if happy[0] == "/" then
     puts "I'm here after /"
     happy.slice!(0)
     param = happy.split(" ")
     puts "param: #{param}"
     cmd = param.delete_at(0)
     puts "cmd: #{cmd}"

     if !cmd.nil? then
      msgsent = !(%w(u a c cw wg l p w gd).include?(cmd.downcase))
    
			case cmd.upcase
			when "U"; displaywho
			when "A"; listactions
			when "C"; changechannel(parameters)
			when "CW"; whoinchannel(@users[@c_user].channel,true)
			when "WG"; globallist
			when "L"; listchannels
			when "P"; msgsent = page
			when "G"; leave
			when "W"; displaywhois (param)
			when "D"; insert, line = directed(param)
			when "Q"
				chan.line = "%M#{@users[@c_user].alais} %Yhas left the teleconference";
				chan.from = nil;
				chan.count -= 1;
				chan.usrchannel.delete(@c_user);
				q = true
			end
		end
  end
		return insert, line, msgsent, q
	end

	def displayhelp(cmds)
		subtopics = {
			"authors" => "gd_help_authors",
			"talking" => "gd_help_talk",
			"commands" =>"gd_help_commands",
			"jets" => "gd_help_jets",
			"abms" => "gd_help_abms",
			"missles" => "gd_help_missles",
			"whisper" => "gd_help_whisper",
			"starting" =>"gd_help_start",
			"death" => "gd_help_death",
			"turn" => "gd_help_turn",
			"intro" => "gd_help_intro",
			"tables" => "gd_help_tables",
			"items" => "gd_help_items"
		}
    
    if !cmds.empty? then
      
     if cmds[0].upcase == "HELP" then
       
      if cmds.length > 1 then
			 s = subtopics[cmds[1].downcase] || "gd_main"
			 ogfileout(s,1,true)
      else
       ogfileout("gd_main",1,true)
     end
     return(false)
   end
  end
   return(true)
end

	def displaywhois(pullapart)
    
    chan = @channel[@users[@c_user].channel]
		if !pullapart.nil? then
			to = whois(pullapart[0])
			if to != nil then
				if pullapart.length > 1 then
					pullapart.slice!(0)
					message = pullapart.join(" ")
					pg = "%RPM %Y(%Gfrom %M#{@users[@c_user].alais}%Y): %C#{message}"
					(@users[@users.findalais(to).name].page ||= []).push(pg)
				end
			else
				if chan.type == "Game" then
					to = whois_v(pullapart[0])
					p = "#{@users[@c_user].alais} |WHISPER| #{to}"
					chan.g_buffer.push(p) if to != nil
				end
			end
			print (to == nil) ? "%RUser not at this table." : "%Y--%GPrivate Message Sent%Y--%G"
		end
	end

	def directed(pullapart)

		if !pullapart.nil? then
			to = whois(pullapart[0])
			if to != nil then
				insert = "Directed"
				if pullapart.length > 1 then
					pullapart.slice!(0)
					message = pullapart.join(" ")
					line = "%Y<%Gto %M#{to}%Y>: %C#{message}"
				end
			end
		end      
		return insert, line
	end

	def checkuseralias 
		if @users[@c_user].alais == '' then 
			@users[@c_user].alais = defaultalias(@c_user)
			@users.saveusers
			print <<-here
			%RYou have not selected a chat alias!
			%GYou have been assigned the default alias of %Y#{@users[@c_user].alais}
			%GThis can be changed from the user configuration menu [#%Y%%G]
			here
			return false
		end
		return true
	end
end
