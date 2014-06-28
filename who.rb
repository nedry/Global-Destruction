class Session
  def addtowholist
    @console.puts "-Adding #{@c_user} to Who is Online List"
    u = @users[@c_user]
    @who.append(Awho.create(@c_user,u.citystate,Thread.current,u.level))
  end

  def displaywho
    i = 0
    if @who.len > 0 then
      print "%GUsers Online:"
      cols = %w(Y G C M R).map {|i| "%"+i}
      headings = %w(node user location from level)
      widths = [5,26,21,20,6]
      header = cols.zip(headings).map {|a,b| a+b}.formatrow(widths)
      underscore = cols.zip(['-'*30]*5).map{|a,b| a+b}.formatrow(widths)
      print header
      print underscore
      @who.each_with_index {|w,i|
        temp = 
        print cols.zip([i+1, w.name, w.where, w.location, w.level]).map{|a,b| "#{a}#{b}"}.formatrow(widths)
      }
    else 
      print "No Users on Line.  That's fucked up, because you're on-line. Doh!" 
    end
    print 
  end
end
