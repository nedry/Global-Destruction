class Session

	def displayuser(number)
		user = @users[number]
		ldate = user.laston.strftime("%A %B %d, %Y / %I:%M%p (%Z)") 
		write "%R#%W#{number + 1} %G #{user.name}"
		write "%R [DELETED]" if user.deleted 
		write "%R [LOCKED]" if user.locked
    print
		print <<-here
		%CLast IP:       %G#{user.phone}
		%CEmail Address: %G#{user.address}
		%CLocation:      %G#{user.citystate}
		%CLast On:       %G#{ldate}
		%CPassword:      %G********     
		%CLevel:         %G#{user.level}
		here
	
		print
		print
	end #displayuser

	def usermenu 
    o_prompt = '"%W#{sdir}User [%p] (0-#{@users.len}): "'
		readmenu(
      :initval => 1,
			:range => 0..@users.len,
			:prompt => o_prompt
		) {|sel, upointer, moved|
			if !sel.integer?
				sel.gsub!(/[-\d+]/,"")
			end
      
      displayuser(upointer-1) if moved
      
			case sel
			when "/"; showuser(upointer-1)
			#when "Q"; done = true
      when "Q"; upointer = true
			when "L"; changeuserlevel(upointer-1)
			when "N"; changeusername(upointer-1)
			when "AD"; changeuseremail(upointer-1)
			when "PN"; changeuserphone(upointer-1)
			when "K"; deleteuser(upointer-1)
			when "W"; displaywho
			when "PU"; page    
			when "S"; lockuser(upointer-1)
			when "P"; changepass(upointer-1)
			when "G"; leave
			when "?"; gfileout ("usermnu")
      end # of case
      p_return = [upointer,@users.len]
			#return upointer, done
		}
	end

	def showuser(upointer)
    puts upointer
		if @users.len > -1 then
			displayuser(upointer)
		else 
			print
			print "%RNo Users.  Something is really fucked up!"
		end
	end

	
	def changeuserlevel(upointer)
		prompt = "%WUser Level? (1-255): "
		if upointer != 0 then
			@users[upointer].level = getnum(prompt,1,255)
			@users.saveusers
		else 
			print "%RYou cannot change the access of the SYSOP" 
		end
	end

	def changeusername(upointer)
		prompt = "%WUser Name?: "
		if upointer != 0 then
			@users[upointer].name = getpwd.slice(0..24)
			@users.saveusers
		else 
			print "%RYou cannot change the name of the SYSOP" 
		end
	end

	def changeuseremail(upointer)
		prompt = "%WEnter new email address: "
		address = getinp(prompt).strip
		@users[upointer].address = address
		@users.saveusers
		print
	end

	def changeuserphone(upointer)
		prompt = "%WEnter new phone: "
		phone = getinp(prompt).strip
		@users[upointer].phone = phone
		@users.saveusers
		print
	end

	def deleteuser(upointer)
		if upointer > 0 then
			if @users[upointer].deleted then
				@users[upointer].deleted = false
				print "%GUser ##{upointer} UNdeleted"
			else 
				@users[upointer].deleted = true
				print "%RUser ##{upointer} deleted."
			end
			@users.saveusers
		else
			print "%RYou cannot delete the SYSOP." 
		end
	end

	def lockuser(upointer)
		if @users[upointer].locked then
			@users[upointer].locked = false
			print "%GUser ##{upointer} UNlocked"
		else 
			@users[upointer].locked = true
			print "%RUser ##{upointer} locked."
		end
		@users.saveusers
	end

	def changepass(upointer)
		pswd = getpwd("%WEnter new password: ").strip.upcase 
		pswd2 = getpwd("Enter again to confirm: ").strip.upcase 
		if pswd == pswd2
			print "Password Changed."
			@users[upointer].password = pswd2
			@users.saveusers
		else 
			print "%RPasswords don't match.  Try again." 
		end
	end

end #class Session
