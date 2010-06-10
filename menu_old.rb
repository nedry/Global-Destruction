def readmenu(args)
	dir = +1
	sdir = '+'
	ptr = args[:initval] || 1
	range = args[:range]

	getinp(eval(args[:prompt])) {|inp|
		oldptr = ptr
		sel = inp.upcase.strip 
		case sel
		when ""; ptr = (dir == 1) ? up(ptr, args) : down(ptr, args)
		when "-"; dir = -1; ptr = down(ptr, args)
		when "+"; dir = +1; ptr = up(ptr, args)
		when /\d+/; ptr = jumpto(ptr, sel.to_i, args)
		end 
		moved = (ptr != oldptr)
		ptr, done = yield(sel, ptr, moved)
		sdir = (dir > 0) ? '+' : '-'
		done
	}
end 

def up(ptr, args)
	if ptr < args[:range].last
		ptr = ptr + 1
	else
		print ("%RCan't go higher")
	end
	ptr
end

def down(ptr, args)
	if ptr > args[:range].first then
		ptr = ptr - 1
	else
		print ("%GCan't go lower")
	end
	ptr
end

def jumpto(ptr, newptr, args)
	if args[:range].include?(newptr)
		ptr = newptr
	else
		print "Out of Range."
		ptr
	end
end
