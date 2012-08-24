class Session


	def leave
		@who.user(@c_user).where="Goodbye"
		if yes("Log off now (Y,n)? ", true, false) then
			write "%W"
			gfileout('bye')
			print "NO CARRIER"
			sleep (1)
			hangup
		end
	end

	def youreoutahere
		prompt = "Boot which user number?: "
		which = getnum(prompt,0,@who.len)
		if which > 0 then
			print "Booting User ##{which} from system."
			Thread.kill(@who[which-1].threadn)
		else print "Aborted"
		end
	end

	def commandLoop 
		@who.user(@c_user).where="Main Menu"
		prompt ="%G-=:? for menu%G:=-"
		getinp(prompt){|inp|
			sel = inp.upcase.strip 
			parameters = Parse.parse(sel)
			sel.gsub!(/[-\d]/,"")
			ulevel = @users[@c_user].level

			case sel
			when "G" ; leave
			when "UM"; run_if_ulevel {usermenu}
			when "KL"; run_if_ulevel {log("REWRITE"); print ("%RDelete command send to log queue.")}
			when "P"; teleconference
			when "KU"; youreoutahere if ulevel == 255
			when "%" ; usersettings
			when "PU" ; page 
			when "V"; version
			when "W"; displaywho
      when "H"; ogfileout("gd_score",1,true) 
			when "L"; write "%W"; ogfileout("userlog",3,true) 
			when "X"; ogfileout("sysopmnu",1,true) if ulevel == 255
			when "?"
				gfileout ("mainmnu")
				print "%RX - eXtended Sysop Menu" if ulevel == 255
			end
			false
		}
	end 

	def run_if_ulevel
		if  @users[@c_user].level == 255
			yield
		else
			print "You do not have the access!"
		end
	end
end
