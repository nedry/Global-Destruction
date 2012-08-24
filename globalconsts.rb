DEBUG = false
STAND_ALONE = false
BS = 8 
ESC = 27
DBS =127
CR = 13 
LF = 10 
CTRL_U = 21
CLS ="\e[2J"
HOME = "\e[H"
CRLF = "\r\n"
NOECHOCHAR = 46 
LOW = 0..31
PRINTABLE = 32..126 
TELNETCMD = 250..255
SPACE = " "

IP_PORT = 3000


ECHO = true
NOECHO = false
WRAP = true
NOWRAP = false
VER = "Global Destruction Server .90"
DONE = false

SYSOPNAME = "SYSOP"

TEXTPATH ="text/"

DEFLEVEL = 60
TELESYSOPLEVEL = 192
MAXSESSIONS = 40

MAXPASSWORDMISS = 3

LIDLEWARN = 2
LIDLELIMIT = 3

RIDLEWARN = 10
RIDLELIMIT = 15

COLORTABLE = {
	'%R' => "\e[;1;31;40m", '%G' => "\e[;1;32;40m",
	'%Y' => "\e[;1;33;40m", '%B' => "\e[;1;34;40m",
	'%M' => "\e[;1;35;40m", '%C' => "\e[;1;36;40m",
	'%W' => "\e[;1;37;40m", '%r' => "\e[;31;40m",
	'%g' => "\e[;32;40m", '%y' => "\e[;33;40m",
	'%b' => "\e[;34;40m", '%m' => "\e[;35;40m",
	'%c' => "\e[;36;40m", '%w' => "\e[;31;40m"
}
