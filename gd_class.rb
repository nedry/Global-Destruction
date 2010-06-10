# ////////////////////////////////////////////////////////////////////////
#
#  gd_const.rb -- General Classes for Global Destruction
#  (C) Copyright 1992, High Velocity Software, Inc.
#  (C) Copyright 2002, Fly-By-Night Software (Ruby Version)
#
#   //////////////////////////////////////////////////////////////////////// */

class Incoming_Object

 def initialize (card,weapon,country,f_user,spy_mode)
  @card	= card
  @weapon	= weapon
  @country	= country
  @f_user	= f_user
  @abm	= NO_CARD
  @spy_mode = spy_mode
 end

 attr_accessor :card, :weapon, :country, :f_user, :abm, :spy_mode
end # of class country

class Player

 def initialize (name,alais,country,virtural,hand)
  @name		 	= name
  @alais	 		= alais
  @virtural	 		= virtural
  @country	 		= country
  @population	 	= random(MIN_POPULATION..MAX_POPULATION)  
  @s_population	 	= @population
  @kills	 		= 0
  @countdown	 	= 0		#generic countdown for active weapon expiration.  Used with Bomber.
  @dead		 	= false
  @hand		 	= hand
  @defence	 		= []
  @active_weapon 	= 0
  @bomberfuel		= 0
  @incoming		= [] 		#of Incoming_object
  @won			= false	#for the highscore module
  @overkill			= 0		#for the highscore module
 end

  attr_accessor :name, :alais, :virtural, :country, :population, :kills, :countdown, :dead, :hand, :defence, :active_weapon, :incoming, :bomberfuel, :won, :overkill
end

class Players

 include Enumerable 

 def initialize 
 @players = [] 
 end 

attr_accessor :name, :virtural, :country, :population, :kills, :dead

 def append(aPlayer) 
  #puts "GD: -Adding a Player"
  @players.push(aPlayer) 
 end 


 def [](key) 
  if key.kind_of?(Integer) 
   result = @players[key] 
  else 
   result = @players.find { |players| key == players.name } 
  end 
 return result 
 end 

 def len
  return @players.length 
 end
end   #of Class channel	


class Irc_user

 def initialize (irc_alias,realname,description)
	 @irc_alias		= irc_alias
	 @realname		= realname
	 @description	= description
 end
  
 attr_accessor :irc_alias, :realname,:description
end

class On_Channel

  include Enumerable 
   
  def initialize 
     @on_channel = [] 
  end 
   
 attr_accessor :irc_alias, :realname, :description
 
  def append(irc_user) 
   #puts "-Adding a irc_user"
   @on_channel.push(irc_user) 
  end 
  
  def clear
   #puts "-Clearing User List"
   @on_channel.clear
  end 
  
  def each
    @on_channel.each {|n| yield n}
  end

  def each_index
   @on_channel.each_index {|i| yield i}
  end

  def each_with_index
   @on_channel.each_with_index {|n,i| yield n,i}
  end
  
  def [](key) 
   if key.kind_of?(Integer) 
      result = @on_channel[key] 
    else 
     result = @on_channel.find { |irc_user| key == irc_user.alias } 
    end 
    return result 
  end 
  
  def len
   
    return @on_channel.length 
  end
 end   #of Class On_channel
 
