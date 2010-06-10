# ////////////////////////////////////////////////////////////////////////
#
#  gd_const.rb -- General Constants for Global Destruction
#  (C) Copyright 1992, High Velocity Software, Inc.
#  (C) Copyright 2002, Fly-By-Night Software (Ruby Version)
#
#   //////////////////////////////////////////////////////////////////////// */

MINPLAYERS = 1

HELPURL 		= "http://www.retrobbs.org/gd/help.html"
GD_VERSION	= ".90"



POP_CHARACTER		= 0x02       # Smiley face.
MAX_BOMBS			= 5
OVERKILL_LEVEL		= -40

SPYCOUNTERCHANCE 	= 75
JETCHANCE			= 75

INPUT_NORMAL		= 1
INPUT_TARGET		= 2
INPUT_ABM			= 3
INPUT_SPY			= 4

TIME_WARN		 = 120        # in seconds
TIME_LIMIT         = 360        # total limit


SPYMODEDESC = [ "gain information about our population",
			  "get specifications about our defensive weapons",
			  "sabotage our defensive arsenal",
			  "sabotage our active offense"]




#When a player whispers a message to a virtual player,
#the virtual player will randomly choose one of these
#messages and whisper it back to the player.  You can
#add or remove entries in this message, as long as each
#one is one-line long.

VWHISP = [
"Why bother whispering to me?  I'm just a virtual person.",
"Are you trying to antagonize me?  I think I'll nuke your pants off!",
"Don't even bother trying to talk to me.  I'm not real.",
"Do you often talk to computer-generated personalities?",
"Go away.",
"Your mother swims out to meet troop ships!",
"Your father winds clocks for a living!",
"Bah!  I shall feast on your bones!",
"You want to chew on a plutonium popsicle?  Stop bothering me.",
"I'm planning global conquest, stop distracting me!",
"I bet you say that to all the guys.  *wink*"]

#When a nuclear bomb detonates, a word from this list will
 #be chosen to describe the holocaust.

NUKILL = [
	"incinerating",
	"toasting",
	"frying",
	"killing",
	"roasting",
	"wasting",
	"decimating",
	"annihilating",
	"irradiating",
	"zapping",
	"baking",
	"crisping",
	"smoking",
	"slaughtering",
	"taking out",
	"char-broiling",
	"eradicating",
	"blowing away",
	"obliterating"]

TURNS_TO_PEACE	= 3

DIE_SIZE			= 6 #Remember: 2 dice per 10 megatons!

# Starting Range of population (in Millions)

MIN_POPULATION		= 220
MAX_POPULATION		= 280

#MIN_POPULATION		= 20
#MAX_POPULATION		= 30

# These are the names of the virtual players, those
# controlled by the BBS.  

VNAMES = [
"Moammar_Khadafy",
"Bill_Gates",
"Donald_Rumsfeld",
"Fidel_Castro",
"Richard_Nixon"]

# These are the country names that the virtual players
# will attempt to grab when they start up.  

VCOUNT= [
"Libya",
"Redmond",
"Iraq",
"Cuba",
"United States"]

# This is the list of countries that will be used when
#playing Global Destruction. 

CTRIES = [
	"United States",
	"Libya",
	"Iraq",
	"Las Vegas",
	"Japan",
	"Cuba",
	"Syria",
	"Siberia",
	"Transylvania",
	"Latin America",
	"Italy",
	"Lambadia",
	"Germany",
	"Antarctica",
	"Monaco",
	"Ireland"]
	

RANKKILLS =
  [100000,40000,28000,24000,20000,16000,13000,10000,
  7400,7000,5000,4000,3000,1800,1200,700,300,100,0]

RANKNAMES = [
  "Duke of Destruction", "Nuclear Nightmare",
  "Death Machine", "Decimator", "Warmonger",
  "Mutilator", "Biohazard", "Destroyer",
  "Flamethrower", "Kiddie Krisper", "Terrorist",
  "Saboteur", "Violator", "Bloodletter",
  "Pyromaniac", "Menace", "Nuisance",
  "Peacekeeper", "Diplomat"]


# MoammarKhadafy

VTALK1 = [
"toasts %s",
"Burn, %s, burn!",
"May the heat of the desert scorch your soul, %s!",
"%s should be thankful my navy is still underwater!",
"None shall slay me, especially not %s.",
"I'll bake you like a chocolate chip cookie, vile %s!",
"Hahahahahahaha!",
"%s, your glowing corpse will make a good nightlight in my bedroom.",
"%s I'll get you, you worm!"]

# Bill Gates

VTALK2 = [
"smacks %s",
"640K ought to be enough for anybody.",
"Microsoft will destroy you, %s!",
"Do not resist me, %s, for I cannot be stopped.",
"The many geeky flying monkeys will overcome you, %s.",
"It's not a bug, it's a feature!",
"%s!  Surrender now, foolish linux user!",
"Heh... heh... heh!",
"Be nice to nerds. Chances are you'll end up being nuked by one, %s!",
"Prepare to meet the mighty Bill face to face, %s!"]


#Saddam Hussian
VTALK3 =[
"slugs %s",
"The Republican Guard shall destroy %s!  Bahahah!",
"Why struggle against my inevitable domination, %s?",
"You shall rot in a dark hole, %s.",
"The Holy Land shall belong to me, religious zealot and overlord!",
"I'm not afraid of you, %s!",
"Ahh-ha!  I have you just where I want you, %s!",
"Muahahahahahaha.",
"Chew on the mother of all warheads, %s!",
"I will kill you all, then kill you again!",
"I will gnaw on your bones, %s!",
"/%s Don't mess with me!"]

#FidelCastro

VTALK4 = [
"grumble",
"Submit to my will, heinous toady!",
"Heh heh heheheh heh heheheh heh.  That was cool.",
"Curse you, %s!  You will not escape me, dog!",
"The light of my cigar will show the way to glory.",
"Not by the hair on my chinny-chin-chin, %s!",
"You'll beg for mercy, %s!  Mark my words!",
"Bahahahah!  %s is incapable of contesting me.",
"Go to your glory, my nuclear lovetoy!",
"Let fire fill the sky!",
"Hey, %s, all I wanted to be was center field.."]

#RichardNixon

VTALK5 = [
"grin %s",
"V isn't for victory!  It's for very overcooked, like %s will soon be!",
"If %s thought Watergate was bad, just wait for Firegate!  Muahah!",
"Vote for me or I'll detonate this bomb over your country!",
"Peace?  Who needs peace when you can have hydrogen bombs?",
"Soon the whole world will know the joy of fast food!",
"All must die.",
"I didn't do that, and you couldn't prove it anyway.",
"Unfgh!",
"I love that little red button!",
"/%s Grrrrrrrrrrrrrrrrrrrrrrr..."]
	
