#/* ////////////////////////////////////////////////////////////////////////
#
#   gd_cards.rb -- Table of all card types for Global Destruction.
#   (C) Copyright 1992, High Velocity Software, Inc.
#   (C) Copyright 2002, Fly-By-Night Software (Ruby Version)
#
#   //////////////////////////////////////////////////////////////////////// 


 RANDTHUNDERBOLT 	= 1
 RANDPOPDEATH 		= 2
 RANDLOSETURN 		= 3
 RANDAEGIS 		= 4
 
 AEGIS			= 1
 THUNDERBOLT		= 7
 MIRVI			= 12
 MT12			= 18
 JET				= 24
 BOMBER			= 25
 SPECIAL			= 26
 COUNTERSPY		= 27
 SPY				= 28
 MIRV			= 29

 HANDLEMIRVMISSLE	= 1
 HANDLEMISSILE 		= 2
 HANDLEWARHEAD	= 3
 HANDLEDEFCARD 	= 4
 HANDLEPOPULATION 	= 5
 HANDLEPERSUASION 	= 6
 HANDLEBOMBER 		= 7
 HANDLERANDOM 		= 8
 HANDLESPY 		= 9
 HANDLEMIRVMISSILE	= 10
 
 NO_CARD			= 0
 CARD_NONE		= 0
 CARD_MISSILE		= 1			# 1-6
 CARD_WARHEAD 	= 2			# 10, 20, 50, 100, 150 mt (1-6)
 CARD_ABM			= 3			# 1-6
 CARD_BOMBER		= 4			# Bombers.
 CARD_FIGHTER		= 5			# Jet fighters (anti bombers).
 CARD_POPULATION	= 6			# Negative or positive.
 CARD_PERSUASION	= 7			# Population mangling without guns.
 CARD_RANDOM		= 8			# Random card.
 CARD_COUNTERSPY	= 9			# Spy defensive card.
 CARD_SPY			= 10			# Spy offensive card.
 CARD_MIRV		= 11			# MIRV Missile

 CARD_COLOUR 	        = {3 => "%G", 1 => "%g", 2 => "%R",7 => "%C", 6 => "%C", 
			             5 => "%W", 4 => "%W", 8 => "%W",9 => "%W", 10 => "%W", 
				     11 => "%R"}
 MAX_CARDS		= 32			# If nCards passes this, bad news!

 MAX_DEFENCE		= 32
 MAX_HAND		= 32
 NO_HIT			= 999

 STARTING_CARDS	= 25
 FLAG_NODEAL    	= 0x0001		#This card should never be dealt.
 
 CHABM			= "chabm"		#Big Handy Help File Names
 CHMISS			= "chmiss"
 CHWAR			= "chwar"
 CHPERS			= "chpers"
 CHPOP			= "chpop"
 CHJET			= "chjet"
 CHBOMBR			= "chbombr"
 CHSECRET			= "chsecret"
 CHCSPY			= "chcspy"
 CHSPY			= "chspy"
 CHMIRV			= "chmirv"
 
 PERSM1			= 1
 PERSM2			= 2
 PERSM3			= 3
 
 POPM1			= 1
 
 
class Special
 
   def initialize (pfnRandom,weight,target)
  
     @pfnRandom			= pfnRandom
     @weight			= weight
     @target			= target
  end
 attr_accessor :pfnRandom, :weight, :target
end

  
class Card

  def initialize (name,sname,help,type,n_cards,level,damage,special,flags,pfn_card,message)
  
    @name		= name		#What is the name of the card?
    @sname		= sname		#The Search Name (the first word...)
    @help		= help		#Message number for big handy help.
    @type		= type		#What type of card is it? (by CARD_xxxxxx)
    @n_cards	= n_cards		#How many of this kind are there?
    @level		= level		#Level of the card.
    @damage	= damage		#Generic counter for damage values.
    @special	= special		#Percentage chance to do special thing.
    @flags		= flags		#General-purpose flags for the cards.
    @pfn_card	= pfn_card		#Function to handle player playing this.
    @message	= message		#Message for special handling
  end
 attr_accessor :name, :sname, :help, :type, :n_cards, :level, :damage, :special, :flags, :pfn_card, :message
end
  

class Deck

  include Enumerable 
   
  def initialize 
  

    @deck = [] 
    @total_cards = 0

  end 
   attr_reader :name, :help, :type, :n_cards, :level, :damage, :special, :flags, :pfn_card, :message, :total_cards
   
  def append(aCard) 
   puts "GD: -Adding a Card"
   @channel.push(aCard) 
   self 
  end 

  def [](key) 

   if key.kind_of?(Integer) 
      result = @deck[key] 
    else 
     result = @deck.find { |deck| key == deck.name } 
    end 
    return result 
  end 
  

  def len
    return @deck.length 
  end
  
  def show_all
   @deck.each {|deck| 
			puts
			puts deck.name
			puts deck.sname
			puts deck.help
			puts deck.n_cards
			puts deck.level
			puts deck.damage
			puts deck.special
			puts deck.flags
			puts deck.pfn_card
			puts deck.message}
  end
  
  def setitup
     count = 0
    @deck.push(Card.new("(None)","",0,0,0,0,0,0,0,0,0))
    @deck.push(Card.new("Aegis VI","Aegis",CHABM,CARD_ABM,8,6,0,0,0,HANDLEDEFCARD,0))
    @deck.push(Card.new("Nexus V","Nexus",CHABM,CARD_ABM,12,5,0,0,0,HANDLEDEFCARD,0))
    @deck.push(Card.new("Avatar IV","Avatar",CHABM,CARD_ABM,18,4,0,0,0,HANDLEDEFCARD,0))
    @deck.push(Card.new("Patriot III","Patriot",CHABM,CARD_ABM,25,3,0,0,0,HANDLEDEFCARD,0))
    @deck.push(Card.new("Guardian II","Guardian",CHABM,CARD_ABM,28,2,0,0,0,HANDLEDEFCARD,0))
    @deck.push(Card.new("Liberator I","Liberator",CHABM,CARD_ABM,30,1,0,0,0,HANDLEDEFCARD,0))
    
    @deck.push(Card.new("Thunderbolt VI","Thunderbolt",CHMISS,CARD_MISSILE,12,6,0,0,0,HANDLEMISSILE,0))
    @deck.push(Card.new("Hellbore V","Hellbore",CHMISS,CARD_MISSILE,18,5,0,0,0,HANDLEMISSILE,0))
    @deck.push(Card.new("Ares IV","Ares",CHMISS,CARD_MISSILE,24,4,0,0,0,HANDLEMISSILE,0))
    @deck.push(Card.new("Trident III","Trident",CHMISS,CARD_MISSILE,38,3,0,0,0,HANDLEMISSILE,0))
    @deck.push(Card.new("Viper II","Viper",CHMISS,CARD_MISSILE,42,2,0,0,0,HANDLEMISSILE,0))
    
    @deck.push(Card.new("MIRV Component I","",CHMISS,CARD_MISSILE,0,1,0,0,FLAG_NODEAL,HANDLEMISSILE,0))
    
    @deck.push(Card.new("150 mt VI","150",CHWAR,CARD_WARHEAD,10,6,30,0,0,HANDLEWARHEAD,0))
    @deck.push(Card.new("100 mt V","100",CHWAR,CARD_WARHEAD,15,5,20,0,0,HANDLEWARHEAD,0))
    @deck.push(Card.new("70 mt IV","70",CHWAR,CARD_WARHEAD,20,4,14,0,0,HANDLEWARHEAD,0))
    @deck.push(Card.new("40 mt III","40",CHWAR,CARD_WARHEAD,30,3,8,0,0,HANDLEWARHEAD,0))
    @deck.push(Card.new("20 mt II","20",CHWAR,CARD_WARHEAD,35,2,4,0,0,HANDLEWARHEAD,0))
    @deck.push(Card.new("12 mt I","12",CHWAR,CARD_WARHEAD,95,1,2,0,0,HANDLEWARHEAD,0))
    
    @deck.push(Card.new("Brainwashing","Brainwashing",CHPERS,CARD_PERSUASION,12,3,10,50,0,HANDLEPERSUASION,PERSM3))
    @deck.push(Card.new("Persuasion","Persuasion",CHPERS,CARD_PERSUASION,18,2,5,30,0,HANDLEPERSUASION,PERSM2))
    @deck.push(Card.new("Misinformation","Misinformation",CHPERS,CARD_PERSUASION,24,1,2,10,0,HANDLEPERSUASION,PERSM1))
    
    @deck.push(Card.new("Super Immigration","Super",CHPOP,CARD_POPULATION,6,2,5,0,0,HANDLEPOPULATION,POPM1))
    @deck.push(Card.new("Immigration","Immigration",CHPOP,CARD_POPULATION,12,1,2,0,0,HANDLEPOPULATION,POPM1))
    
    @deck.push(Card.new("Jet Fighter","Jet",CHJET,CARD_FIGHTER,12,0,0,0,0,HANDLEDEFCARD,0))
    
    @deck.push(Card.new("Bomber","Bomber",CHBOMBR,CARD_BOMBER,12,0,0,0,0,HANDLEBOMBER,0))
    
    @deck.push(Card.new("Special","Special",CHSECRET,CARD_RANDOM,15,0,0,0,0,HANDLERANDOM,0))
    
    @deck.push(Card.new("Counter Intellegence","Counter",CHCSPY,CARD_COUNTERSPY,32,0,0,0,0,HANDLEDEFCARD,0))
    @deck.push(Card.new("Spy","Spy",CHSPY,CARD_SPY,32,0,0,0,0,HANDLESPY,0))
    
    @deck.push(Card.new("MIRV Missile","MIRV",CHMIRV,CARD_MIRV,16,0,0,0,0,HANDLEMIRVMISSILE,0))
    @deck.each { |deck| count = count + deck.n_cards }
    @total_cards = count

  end
  
 def choosehand
 
  hand	= []
  i		= 0
  
  STARTING_CARDS.times {hand.push(choosecard)}
  hand.sort!
  return hand
 end
 
 def choosecard


  target	= rand(@total_cards)
  cardhit 	= NO_CARD
  i		= 0
  count	= 0

  for i in 1..@deck.length - 1 
   count = count + @deck[i].n_cards 
   if count >= target
    cardhit = i  
    break
   end
  end

  puts "GD: Oh shit, no card found in card picker" if cardhit == 0 

  return cardhit
 end
    
 end   #of Class Deck

 def display_hand (user,hand)
  i 		= -1
  count 	= 1
  
  u = user
  hand.sort!
  
  blat_usr_b(user,"%MStock:")

  
  until i == hand.length - 1
     i += 1
   while true
    break if hand[i+1] != hand[i]
    count = count.succ
    i += 1
   end
   
    # blat_usr_b(user," %M#{count}-%Y #{CARD_COLOUR[@deck[hand[i]].type]}#{@deck[hand[i]].name}")
    blat_usr(user," %M#{count}-%R #{CARD_COLOUR[@deck[hand[i]].type]}#{@deck[hand[i]].name}")
  count = 1
 end
  blat_usr(user,"***")
end

 def display_defence (user,hand)
  i 		= -1
  count 	= 1

  
  u = user
  hand.sort!
  
  blat_usr_b(user,"%MDefence:")

  
  until i == hand.length - 1
     i = i.succ
   while true
    break if hand[i+1] != hand[i]
    count +=1
    i +=1
   end  
 
  

  blat_usr_b(user," %W#{count}-%Y #{@deck[hand[i]].name}")

  count = 1
 end
 blat_usr_b(user,"***")
end

 def display_abm (user,hand)

 i 		= 0
 j		= 0
 level 	= 0

  u = user
  hand.delete(JET)		#make sure no Jet Fighters get into the list...
  hand.sort!
  hand.reverse!
  
 
  blat_usr_b(user,"%MABM's to Fire:")

 for k in 1..6 do
  level = 0
  level = @deck[hand[i]].level  if i <= hand.length - 1 
  if level != k then
    blat_usr_b(user," %M[#{k}] %M0 - %Y#{@deck[7 - k].name}")
   else
    while true
     j = j.succ
     
     break if hand[i+1] != hand[i]
     i = i.succ
    end #of while
   if @deck[hand[i]].type == CARD_ABM then
    blat_usr_b(user," %M[#{k}] %M#{j} - %Y#{@deck[hand[i]].name}")
    i = i.succ
    j = 0
  end #of if @deck
  end #of if hand
 end
#blat_usr(user,"***")
#end
end #of def



 
 