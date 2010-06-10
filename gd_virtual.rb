 def display_hand_v (user,hand)
  i 		= -1
  count 	= 1
  
  u = user
  hand.sort!
  
  out = ""
  
  until i == hand.length - 1
     i += 1
   while true
    break if hand[i+1] != hand[i]
    count = count.succ
    i += 1
   end
    out = out +" [#{count}] #{@deck[hand[i]].name} - "
    count = 1
 end
 puts("DEBUG: #{out}")
end

def acquirerandomtarget  #return a random target that isn't myself
 
 while true
  choice = rand(@players.len)
  puts "DEBUG: choice: #{choice}"
  break if choice != @turn and !@players[choice].dead
 end
 return choice
end

def countcard(card)
  hand = @players[@turn].hand
  cards = 0

  for i in 0..hand.length - 1 do
   cards += 1 if hand[i] == card
  end
  puts("DEBUG: Countcard #{cards} of card #{@deck[card].name} found.")
 return cards
end

def countcard_defence(card)
  hand = @players[@turn].defence
  cards = 0

  for i in 0..hand.length - 1 do
   cards += 1 if hand[i] == card
  end
  puts("DEBUG: Countcard_defence #{cards} of card #{@deck[card].name} found.")
 return cards
end

def countcardtype(c_type)

  hand = @players[@turn].hand
  cards = false
  
 for i in 0..hand.length - 1 do
  cards = true if @deck[hand[i]].type == c_type
 end     
    puts("DEBUG: #{cards} had has cards of type #{c_type}.")
  return cards
 end
 
 def seekcard(type,level)
  
  
  hit = false

  for i in 0..MAX_CARDS - 1 do
    if @deck[i].type == type and @deck[i].level == level then
      hit = true
      break
    end
  end

  if hit then
    return i
  else
    puts( "DEBUG: Could not seek card: #{type} #{level}")
    return NO_CARD
  end
end

def virtualtalk(target)

  msg = VCOUNT.index(@players[@turn].country)
  case msg
    when 0
     which = rand(VTALK1.length)
     out = VTALK1[which].gsub("%s",@players[target].name)
    when 1
     which = rand(VTALK2.length)
     out = VTALK2[which].gsub("%s",@players[target].name)
    when 2
     which = rand(VTALK3.length)
     out = VTALK3[which].gsub("%s",@players[target].name)
    when 3
     which = rand(VTALK4.length)
     out = VTALK4[which].gsub("%s",@players[target].name)
    when 4
     which = rand(VTALK5.length)
     out = VTALK5[which].gsub("%s",@players[target].name)
   end
	puts("DEBUG: which: #{which} msg: #{msg}")
        blat("%G<#{VNAMES[msg]}> %C#{out}")
end

def attemptwarhead
  

  mounted = false
  topwarhead = seekcard(CARD_WARHEAD, 6)
  missilelevel = @deck[@players[@turn].active_weapon].level

  while @deck[topwarhead].type == CARD_WARHEAD

    if @deck[topwarhead].level <= missilelevel and countcard(topwarhead) > 0 then
        mounted = true
	target = acquirerandomtarget
	m_liftoff(@players[target].name,@deck[@players[@turn].active_weapon].name,@players[@turn].country)
	m_missile_on_way(@turn,@players[target].country)
	m_missile_away(@turn,@players[target].name,@deck[@players[@turn].active_weapon].name,@players[@turn].country,@players[target].country)
	remove_from_hand(@turn,topwarhead)
	add_to_incoming(@players[target].name,Incoming_Object.new(topwarhead,@players[@turn].active_weapon,@players[@turn].country,@turn,nil))
	remove_active_weapon(@turn)
        virtualtalk(target) if percentodds(20) 
       break
     end
    topwarhead += 1
 end

  if !mounted
    puts("DEBUG: Could not find valid warhead to mount")
  end
  return mounted
 end
 
def attemptbomberwarhead
  
  
  mounted = false
  topwarhead = seekcard(CARD_WARHEAD, 5)

  while @deck[topwarhead].type == CARD_WARHEAD

    if @deck[topwarhead].level <= 5 and countcard(topwarhead) > 0
        mounted = true
	target = acquirerandomtarget
	remove_from_hand(@turn,topwarhead)
        virtualtalk(target) if percentodds(20)
	m_liftoff(@players[target].name,@deck[@players[@turn].active_weapon].name,@players[@turn].country)
	m_missile_away(@turn,@players[target].name,@deck[@players[@turn].active_weapon].name,@players[@turn].country,@players[target].country)
	add_to_incoming(@players[target].name,Incoming_Object.new(topwarhead,@players[@turn].active_weapon,@players[@turn].country,@turn,nil))
        break
    end

    topwarhead +=1
end

  if !mounted then
    puts("DEBUG: Could not find valid warhead to mount on bomber");
  end
  return mounted
end

def attemptMIRVwarhead
  
  target = acquirerandomtarget
  tenindex = seekcard(CARD_WARHEAD, 1)
  fired = 0

  fired = countcard(tenindex)

  fired = MIRV_COUNT if fired > MIRV_COUNT 
 
  fired.each {remove_from_hand(@turn,tenindex)
		  add_to_incoming(@players[target].name,Incoming_Object.new(result,MIRVI,@players[@turn].country,user,nil))
		  }

  remove_active_weapon(@turn)

  virtualtalk(target) if percentodds(70)
end

def playspy
  
  spyindex = seekcard(CARD_SPY, 0)
  target = acquirerandomtarget
  mode = 2

  mode += 1 if @players[target].active_weapon != NO_CARD and percentodds(50)

  add_to_incoming(@players[target].name,Incoming_Object.new(spyindex,spyindex,@players[@turn].country,@turn,mode))
  remove_from_hand(@turn,spyindex)
end

def playpersuasion
  
  pers = seekcard(CARD_PERSUASION, 3)
  played = false


  while @deck[pers].type == CARD_PERSUASION
    
    if countcard(pers) > 0 then
      played = true
      target = acquirerandomtarget
      hits = @deck[pers].damage 
      moved = damage(hits)
      moved == @players[target].population - 1 if moved > @players[target].population 
      @players[@turn].population = @players[@turn].population + moved
      @players[target].population = @players[target].population - moved
      remove_from_hand(@turn,pers)

		 case card_message
                  when PERSM1
                   blat(persuasion1_message(@players[@turn].country,@players[target].country,moved))
                  when PERSM2
                   blat(persuasion2_message(@players[@turn].country,@players[target].country,moved))
                  when PERSM3
                   blat(persuasion3_message(@players[@turn].country,@players[target].country,moved))
                  end #of Case card_message
		 handle_kaboom(@turn)
		 boom(target)
      break
    end

    pers += 1
   end

  return played
 end

def playsecret

 target = acquirerandomtarget
 to_play = choose_randomcard
 secretcard = seekcard(CARD_RANDOM, 0)
 puts "DEBUG: #{@randoms[to_play].pfnRandom}"
  case @randoms[to_play].pfnRandom
 
   when RANDTHUNDERBOLT
     if @randoms[to_play].target then
      m_give_thunderbolt_v(@turn,target)
      @players[target].hand.push(THUNDERBOLT)
     else
      @players[@turn].active_weapon = THUNDERBOLT
     end
		     
   when RANDPOPDEATH
     puts "DEBUG: Population death"
     hits = rand(3)+1
     killed = damage(hits)
     country = @players[@turn].country
     @players[target].country if @randoms[to_play].target
      blat(popdeath_message(country,killed))
     if @randoms[to_play].target
      @players[target].population = @players[target].population - killed
     else
      @players[@turn].population = @players[@turn].population - killed
     end
      boom(target)
      boom(@turn)
		     
     when RANDLOSETURN
      blat(loseturn_message(@players[@turn].country))
                   
     when RANDAEGIS
       puts "DEBUG: Random Aegis"
       if @randoms[to_play].target then
        m_give_aegis_v(@turn,target)
        @players[target].defence.push(AEGIS)
      else
       m_recieve_aegis(@turn)
       @players[@turn].defence.push(AEGIS)
      end
		     
    end #of case
		    
  remove_from_hand(@turn,secretcard)		    

end


def playpopulation
  
  toppop = seekcard(CARD_POPULATION, 2)
  found = false

  while @deck[toppop].type == CARD_POPULATION

    if countcard(toppop) > 0 then
     hits = @deck[toppop].damage 
     new = damage(hits)
     @players[@turn].population = @players[@turn].population + new
     puts "DEBUG: Playing card #{toppop}"
     puts "DEBUG: Playing level #{@deck[toppop].level}"
     puts "DEBUG: playing name #{@deck[toppop].name}"
      remove_from_hand(@turn,toppop)
     blat (population_message(@players[@turn].country))
      found = true
      break
    end

    toppop += 1
  end

  if !found
 puts  ("DEBUG: !!! Unable to find a population!")
  end
 end

def playABM
  
  topmissile = seekcard(CARD_ABM, 6)
  found = false
  jet = seekcard(CARD_FIGHTER, 0)
  cSpy = seekcard(CARD_COUNTERSPY, 0)

 puts("DEBUG: Attempting to play a defence card")


  if percentodds(35) and countcard(jet) > 0 then
   @players[@turn].defence.push(jet)
   puts "DEBUG: *** Playing a jet"
     puts "DEBUG: *** Playing card #{jet}"
     m_setting_up_defence(@turn,@players[@turn].country)
    remove_from_hand(@turn,jet)
    return
  end


  if percentodds(35) and countcard(cSpy) > 0 then
  
    @players[@turn].defence.push(cSpy)
       puts "DEBUG: *** Playing a counter spy"
     puts  "DEBUG: *** Playing card #{cSpy}"
     m_setting_up_defence(@turn,@players[@turn].country)
    remove_from_hand(@turn,cSpy)
    return
  end


  while @deck[topmissile].type == CARD_ABM

    if countcard(topmissile) > 0 then
     @players[@turn].defence.push(topmissile)
        puts "DEBUG: *** Playing a abm"
     puts  "DEBUG: *** Playing card #{@deck[topmissile].name}"
      m_setting_up_defence(@turn,@players[@turn].country)
      remove_from_hand(@turn,topmissile)
     found = true
     break
    end

    topmissile+=1
 end

  if !found then
    puts("DEBUG: !!! Unable to find an ABM!")
  end
end

 def playmissile
  
  topmissile = seekcard(CARD_MISSILE, 6)
  mirvindex = seekcard(CARD_MIRV, 0)
  tenindex = seekcard(CARD_WARHEAD, 1)
  tenindex = 0
  found = false
  bomber = seekcard(CARD_BOMBER, 0)

  if percentodds(35) and @players[@turn].hand.index(bomber) then
   @players[@turn].active_weapon = bomber
   remove_from_hand(@turn,bomber)
   m_bomber_ready(@turn)
   @players[@turn].bomberfuel = MAX_BOMBS
   return
  end

  if countcard(tenindex) > 3 and countcard(mirvindex) > 0 and percentodds(99) then
   @players[@turn].active_weapon = mirvindex
   remove_from_hand(@turn,mirvindex)
   m_opponent_readied_missile(@turn,@players[@turn].country,@deck[@players[@turn].active_weapon].name)
   return
  end

  while @deck[topmissile].type == CARD_MISSILE
    if countcard(topmissile) > 0 then 
     @players[@turn].active_weapon = topmissile
     remove_from_hand(@turn,topmissile)
     m_opponent_readied_missile(@turn,@players[@turn].country,@deck[@players[@turn].active_weapon].name)
     found = true
     break
    end
   topmissile += 1
 end

  if !found then
    puts("DEBUG: !!! Unable to find a missile!")
  end
 end
 
 
def firevirtualABMs

 max = @players[@turn].incoming.length - 1
  
 for i in 0..max do
  pMissile = @deck[@players[@turn].incoming[i].weapon].level
  puts("DEBUG: pMissile (incoming level): #{pMissile}")
  rightABM = seekcard(CARD_ABM, pMissile);
#  blat "processing missile: #{@deck[@players[@turn].incoming[i].weapon].name}"
#  blat "rightABM Level: #{@deck[rightABM].level}"
#  blat "rightABM Level: #{@deck[rightABM].name}"
  checks = 3

  while @deck[rightABM].type == CARD_ABM
     puts("DEBUG: looping #{checks}")
     puts "DEBUG: rightABM name: #{@deck[rightABM].name}"
    if countcard_defence(rightABM) > 0 then
      puts("DEBUG: Firing abm: #{rightABM}")
      remove_from_defence(@turn,rightABM)
      @players[@turn].incoming[i].abm = rightABM
      break
    else 
    puts("DEBUG: I don't have one...")
    end

    rightABM -= 1
    checks -= 1

    if checks == 0 then        # Don't waste an ABM that's too big.
      break
    end
  end
 end
 end




