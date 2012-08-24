class Session
	def page
		to = getinp("%GUser to Page: ").strip
    return false if to == ""
		if @who.user(to).nil? then
			print "%Y-- %RPage Failed: User not Online%Y --"
      # Don't process more commands that are stacked.
      @cmdstack.cmd.clear 
			return false
		end
		message = getinp("%CMessage: ").strip
		return false if message == "" 

    #yet another linux nil check
		@users[to].page ||= Array.new 
		@users[to].page.push("%CPAGE (%Gfrom #{@c_user}%C): #{message}")
		return true
	end
end
