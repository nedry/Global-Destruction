class Session
	
def version
	print <<-EOP
		%C#{VER} by Fly-By-Night Software

	EOP
	ogfileout("gd_help_authors",1,true) 
end

def crerror
	print <<-EOP
		\r\n%GWhen the software asks you to enter <%YCR%G> it means
		press carriage return, not type a %YC %Gand a %YR%G.
		Thoughtful users will realize that this also means
		press the <%YENTER%G> key.  Have a nice day.\r\n
	EOP
	false
end


def spam
	write('Spam, Spam, Bacon, Spam...');
	sleep (0.5)
	27.times {write(BS.chr); sleep(0.02)}
	27.times {write(SPACE)}
	27.times { write(BS.chr)}
end

end #class Session
