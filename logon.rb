class Session

	def checkpassword (username, password) 
		if @users[username] == nil
			log ("%RERROR   : %Gyou sent def checkpassword a bad username.")
			return false
		else
			return (@users[username].password == password)
		end 
	end 

  def detect_ansi
   print "\e[s"      #Save Cursor Position
   print "\e[99B_"   #locate Cursor as far down as possible
   print "\e[6n"     #Get Cursor Position
   print "\e[u"      #Restore Cursor Position
   print "\e[0m_"    #Set Normal Colours
   print "\e[2J"     #Clear Screen
   print "\e[H"      #Home Cursor

   i = 0
   while i < 50
    i +=1
    test = @socket.getc.ord if select([@socket],nil,nil,0.1) != nil
    if test == ESC
     sleep(2)
     while select([@socket],nil,nil,0.1) != nil
      junk = @socket.getc
     end
     return true
    end
   end
  return false
end

	def figureip(peername)
		i = peername.unpack('snCCCCa8')
		ip = "#{i[2]}.#{i[3]}.#{i[4]}.#{i[5]}"
		return ip
	end

	def logon  
	
		ip= figureip(@socket.getpeername)
	  print
		ddate = Time.now.strftime("%m/%d/%Y at %I:%M%p") 
		log ("%GCONNECT :  %Y#{ddate} %Gfrom IP: %Y#{ip}%G.")
                if detect_ansi then
                 sleep(1)
                 print "ANSI Detected" if STAND_ALONE
                 ansi = true
                else
                 print "ANSI not Detected" if STAND_ALONE
                 ansi = false
							 end
	if STAND_ALONE then	
		spam
		print VER
		print ("IP Address detected: #{ip}")
                if ansi and File.exists?(TEXTPATH + "welcome1.ans") then
                 fileout(TEXTPATH + "welcome1.ans")
                else
		 fileout(TEXTPATH + "welcome1.txt")
                end

		checkmaxsessions

		count = 0

		while true
			count = count + 1
			username = ''
			getinp("Enter your name: ") {|inp| 
				username = inp.strip
			  username != ""
			}
			if username.split.length < 2
				userlastname = getinp("Enter your LAST name or <CR>: ") {|inp|
					inp == "CR" ? crerror : true
				}.strip
				username = (username + SPACE + userlastname).strip
			end

			if @users[username] == nil then
				if yes("Create new user #{username}? (Y,n)",true,false)
					newuser(username, ip)
				else
					next # input name again
				end	
			end

			password = getpwd("Enter password for user #{username}: ")
			break if checkpassword(username.upcase, password) == true
			checkmaxpwdmiss(count,username)
		end #of while...true

		checkkillfile(username)
		checkmultiplelogon
		@who.each {|w|
			@users[w.name].page.push("%C#{@c_user} %Ghas just logged into the system.")
		}
		logandgreetuser(username, ip)
		ogfileout("welcome2",4,true)
	else
		
		getinp(">") {|inp|
						username = inp.strip
			      username != ""
		}
		if @users[username] == nil then
		  @users.append(User.create(username, ip, "auto user", "auto user", "", 24,80, ansi, true, DEFLEVEL)) 
		  @users.saveusers
		  @c_user = @users[username].name
		  log ("%CUSER    :  New user #{@c_user} created.")
		  ogfileout("newuser",2,true)
		  yes("Press <ENTER>",true,false)
		else
		  checkkillfile(username)
		  checkmultiplelogon
		  @who.each {|w|
			@users[w.name].page.push("%C#{@c_user} %Ghas just logged into the system.")
		}
		logandgreetuser(username, ip)
		ogfileout("welcome2",4,true)
		end
	end
	end 

	def checkmaxsessions
		toomany = Thread.list
		if toomany.length > MAXSESSIONS + 3 then
			log("%RSECURITY:  %GMaximum Sessions Exceeded!")
			fileout("toomany.txt")
			sleep(10)
			hangup
		end
	end

	def newuser(username, ip)
		password = nil
		
		while !password
			password = getandconfirmpwd
		end

		prompt = "Enter your Email Address:       : "
		address = getinputlen(prompt,ECHO,6,false)
		prompt = "Enter your Location:            : "
		location = getinputlen(prompt,ECHO,6,false)
		prompt = "ANSI [IBM] Graphics        (Y,n)? "
		ansi = yes(prompt,true,false)
    # work on this.
		more =true

		@users.append(User.create(username, ip, location, address, password, 24,80, ansi, more, DEFLEVEL)) 
		@users.saveusers
		@c_user = @users[username].name
		log ("%CUSER    :  New user #{@c_user} created.")
		ogfileout("newuser",2,true)
		yes("Press <ENTER>",true,false)
	end

	def checkkillfile(username)
		@c_user = @users[username].name
		if @users[@c_user].deleted then 
			log("%RSECURITY:  %Y#{@c_user} %Gtried to log on, but is in the kill file!")
			log("")
			gfileout("killfile") 
			sleep(10)
			hangup
		end
	end

	def checkmultiplelogon
		for x in 0..(@who.len - 1)
			if @who[x].name.upcase == @c_user.upcase then
				log("%RSECURITY:  %Y#{username} %Gtried to log on, but is already on-line")
				log("")
				gfileout("already")
				sleep(10)
				hangup
			end
		end
	end

	def logandgreetuser(username, ip)
		log ("%GUSER    :  %Y#{@c_user} %Glogged on sucessfully.")
		log ("")
		@logged_on = true
		puts "-#{@c_user} logging in."
	  if STAND_ALONE then
		  print "%WGood #{timeofday} #{username}"
		  ddate = @users[username].laston.strftime("%A %B %d, %Y")
		  dtime  = @users[username].laston.strftime("%I:%M%p (%Z)")
		  print "%GYou were last on %B#{ddate} %C #{dtime} %W"
		end
		@users[@c_user].logons += 1
		@users[@c_user].laston = Time.now
		@users[@c_user].channel = 0
		@users[@c_user].phone = ip
		@users[@c_user].page.clear if @users[@c_user].page != nil #yet another linux nil check
		@users.saveusers
		addtowholist
	end

	def checkmaxpwdmiss(count,username)
		if count == MAXPASSWORDMISS then
			fileout("missed.txt")
			log("%RSECURITY:  %Y#{username} %Gmissed his password more than #{MAXPASSWORDMISS} times, and was disconnected.")
			log("")
			sleep(10)
			hangup
		end
	end

end #classSession
