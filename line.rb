require "tools.rb"
require 'globalconsts.rb'

class Session
	def getmsglen
		@lineeditor.msgtext.nil? ? 0 : (@lineeditor.msgtext.length)
	end

	def quoter
		prompt = "[C]ut/Paste [L]ist [R]eturn: " 
		getinp(prompt) {|inp|
			happy = inp.upcase.strip 
			parameters = Parse.parse(happy)
			happy.gsub!(/[-\d]/,"")

			u = @users[@c_user]
			width = u.width - 5

			case happy
			when "L" 
				cont = true
				j = 0
				len	= @curmessage.text ? @curmessage.text.length : 0 
				start, stop = getlinerange(len, parameters)

				write "%W"
				for i in start..stop do
					print "#{i}:  #{@curmessage.text[i - 1]}".slice(0..width)
					j = j.succ
					if j == u.length and u.more then
						cont = moreprompt
						write "%W"
						j = 1
					end
					break if !cont 
				end

			when "C"
				len	= @curmessage.text.length || 0 
				start, stop = getlinerange(len, parameters)
				for i in start..stop
					@lineeditor.msgtext.push(">#{@curmessage.text[i-1]}".slice(0..width))
				end
				print "#{(stop - start + 1)} line(s) quoted"
				len = (@lineeditor.msgtext.nil?) ? 0 : @lineeditor.msgtext.length 
				@lineeditor.line = len + 1
			when "R"
				return
			end #of case
		} 
	end # of def

	def getlinerange(len, *parameters)
		start, stop = parameters[0..1]
		start = 0 if start < 0
		stop = start if stop < start
		if (start == 0) then
			prompt = "Starting line (1-#{len}) or 0 to abort? "
			start = getnum(prompt,0,len)
			return [nil, nil] if start == 0
			prompt = "Ending line (#{start}-#{len}) or 0 to abort? "
			stop = getnum(prompt,0,len) {|i| i == 0 || (start..len).include?(i)}
			return [nil, nil] if stop == 0
		end
		return start, stop
	end

	def displaycolors
		print "%Y"
		@socket.write "Color Changing Codes: "
		COLORTABLE.each {|c| @socket.write "#{COLORTABLE[c]} #{c}"}
    print ""
	end

	def editmenu
		print <<-here
		(A)bort   (C)ontinue   (I)nsert (F)ind (and Replace)
		(D)elete  (E)dit line  (L)ist   (R)eplace line
		(T)itle   (S)ave       (Q)uote

		here
	end

	def replace_line(args)
		len = getmsglen 
		replaceline = args.shift || 0

		prompt = "Replace line (1-#{len}) or 0 to abort? "
		replaceline = getnum(prompt, 0, len)

		return if replaceline == 0

		list [replaceline, 0]
		if yes("Replace this line(y/N)? ",false,false) then
			prompt = "Enter new line or enter <CR> to abort: "
			newline = getinp(prompt)
			if newline == "" then print "Line NOT replaced"
			else 
				print "Line REPLACED."
				@lineeditor.msgtext[replaceline - 1] = newline
			end
		end
	end

	def insert_lines(args)
		len = getmsglen 
		insertline = args.shift || 0 

		if len >= MAXMESSAGESIZE then
			print "No more room!"
			return false
		end	

		insertline = getnum("Insert after which line? ",0,len) if 
		!(1...len).include?(insertline) 

		if (tempint <= len) and (tempint >= 0) then
			@lineeditor.line = (tempint)
			return true
		else 
			print "Invalid input!"
		end
	end

	def delete_lines(parameters)
		len = getmsglen		
		start, stop = getlinerange(len, parameters)
		return if !start 
		@lineeditor.msgtext.slice!(start-1..stop-1)
		print "#{(stop - start + 1)} line(s) deleted"
		@lineeditor.msgtext.compact!
		len = @lineeditor.msgtext ? @lineeditor.msgtext.length : 0
		@lineeditor.line = len + 1
	end

	def edit_line(args) 
		editline = args.shift || 0

		if !(1..len).include?(editline)
			prompt = "Edit line (1-#{len}) or 0 to abort? "  
			editline = getnum(prompt,0,len)
		end

		return if editline == 0

		list editline, 0 

		while (oldline != "")
			getinp("Enter old string: ") {|inp|
				oldline = inp
				break if oldline == ""
				x = @lineeditor.msgtext[tempint-1].index(oldline)
				print "Not found!" if x == nil
				x
			}

			newline = getinp("Enter new string: ") 
			if newline != '' then 
				@lineeditor.msgtext[tempint-1].sub!(oldline,newline) 
			end
		end
	end

	def list(parameters)
		len = getmsglen
		start, stop = getlinerange(len, parameters)
		for i in start..stop do
			print "#{i}:  #{@lineeditor.msgtext[i - 1]}" 
		end
	end

	def editprompt
		@lineeditor.msgtext.compact!

		while true
			prompt = "Edit Prompt: " 
			happy = getinp(prompt).upcase.strip 
			parameters = Parse.parse(happy)
			happy.gsub!(/[-\d]/,"")
			case happy
			when "S"; @lineeditor.save = true; return true
			when "A"; @lineeditor.save = false; return true
			when "C";	return false
			when "E"; edit_line(parameters)
			when "D"; delete_lines(parameters)
			when "L"; list(parameters)
			when "R"; replace_line(parameters)
			when "I"; return false if insert_lines(parameters)
			when "?"; editmenu
			when "Q"; quoter
			end #of case
		end # of until
	end # of def

	def lineedit(startline)

		print "%GEnter message text.  %Y#{MAXMESSAGESIZE}%G lines maximum."
		print "%R/EX for editor prompt, /S to save, /Q to quote, /A to abort."
		if @users[@c_user].ansi then displaycolors end
		write "%C"

		len 		= 0
		done 		= false
		workingline 	= ''
		@lineeditor.line = 1

		@cmdstack.cmd.clear			#clear the command buffer
		@lineeditor.msgtext.clear			#clear the message buffer

		until (done) 

			until (len >= MAXMESSAGESIZE) or (done)
				prompt1 = "#{@lineeditor.line}: "
				write prompt1
				workingline = getstr(ECHO,WRAP,@users[@c_user].width-4,prompt1,false)

				case workingline.upcase.strip 
				when  "/A"; done = true; @lineeditor.save = false
				when "/S"; done = true; @lineeditor.save = true
				when "/Q"; quoter
				when "/EX"; break				#and we fall through the loop to editprompt
				else
					@lineeditor.line += 1
					offset = @lineeditor.line < len ? 2 : 0
					@lineeditor.msgtext[@lineeditor.line - offset,0] = workingline
					len = @lineeditor.msgtext.length
					if len == (MAXMESSAGESIZE - 2) then print "Two Lines Left!" end
				end # of Case

			end # of Inner Until
			if !done then 
				done = editprompt 
			end
		end #of Outer until
		return @lineeditor.save
	end
end #class Session
