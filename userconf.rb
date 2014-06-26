class Session
	def usersettingsmenu
		print <<-here
		%BTerminal Settings                   
		%G(%YG%G)raphics (ANSI) Toggle        
		%G(%YL%G)ines per Page                %G(%YP%G)assword
		%G(%YM%G)ore Prompt Toggle            %G(%YQ%G)uit
		%G(%YW%G)idth                         %G(%Y?%G)This Menu
		here
	end

	def defaultalias(username)

		newname = username.gsub!(/\s+/, "")
		x = 0
		while true
			break if @users.findalais(newname) == nil
			x = x.succ
			newname << x.to_s
		end
		return newname
	end

	def usersettings
		usersettingsmenu
		prompt = "%GChange Which <Q/Exit>: " 
		getinp(prompt) {|inp|
			case inp.upcase.strip 
			when "L"; changelength
			when "W"; changewidth
			when "P"; changepwd
			when "G"; togglegraphics 
			when "M"; togglemore
			when "?";	usersettingsmenu
			when "Q";	done = true
			end
			done
		}
	end 
end #class Session

def changelength
	print "Screen Length is %R#{@users[@c_user].length}%G lines."
	prompt = "Screen length? (10-60) [default=40]: "
	@users[@c_user].length = getnum(prompt,10,60) || 40
	@users.saveusers
end

def changewidth
	print "Screen Width is %R#{@users[@c_user].width}%G characters."
	prompt = "Screen width? (22-80) [default=40]: "
	@users[@c_user].width = getnum(prompt,22,80) || 40
	@users.saveusers
end

def changepwd
	prompt = "Enter Current Password: "
	tempstr = getpwd(prompt)
	if tempstr == @users[@c_user].password then
		if (pswd2 = getandconfirmpwd)
			print "Password Changed."
			@users[@c_user].password = pswd2
			@users.saveusers
		else
			print "Aborted - Password not changed"
		end
	else 
		print "You must enter your old password correctly." 
	end
end


def togglegraphics
	if @users[@c_user].ansi == true
		print "Graphics Now Off"
		@users[@c_user].ansi = false
	else
		@users[@c_user].ansi = true
		print "Graphics Now On"
	end
	@users.saveusers
end

def togglemore
	if @users[@c_user].more == TRUE 
		print "More Prompt Now %ROff"
		@users[@c_user].more = FALSE
	else
		@users[@c_user].more = TRUE
		print "More Prompt Now %GOn"
	end
	@users.saveusers
end

