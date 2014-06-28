
def add_to_incoming(user,object)
  @players[user].incoming.push(object)
end

def v_add (number)

  number.times {
    while true
      nextp = rand(VCOUNT.length)
      if @usd_country.index(nextp) == nil then
        @players.append(Player.new(VNAMES[nextp],VNAMES[nextp],VCOUNT[nextp],true,@deck.choosehand))
        console.puts "DEBUG:Adding: #{VNAMES[nextp]}"
        @channel[@c_num].v_usrchannel.push(VNAMES[nextp])   #add them to the virtual channel in teleconference
        @usd_country.push(nextp)
        break
      else puts "DEBUG:Collision... try again..#{nextp}" end
    end }
end

def v_create_list (number)

  number.times {
    while true
      nextp = rand(VCOUNT.length)
      if @usd_country.index(nextp) == nil then
        @v_players.append(Player.new(VNAMES[nextp],VNAMES[nextp],VCOUNT[nextp],true,@deck.choosehand))
        puts "-Adding: #{VNAMES[nextp]}"
        @channel[@c_num].v_usrchannel.push(VNAMES[nextp])   #add them to the virtual channel in teleconference
        @usd_country.push(nextp)
        break
      else puts "DEBUG:Collision... try again..#{nextp}" end
    end }
end

def v_combine
  @players = Players.new
  @usd_country = []
  i = 0
  puts "@players.len: #{@players.len}"
  for i in 0..@v_players.len - 1
    @players.append(@v_players[i].dup)
    @usd_country.push(@v_players[i].country.dup)
  end
end

def r_add 

  @channel[@c_num].usrchannel.each {|name|

    while true
      nextp = rand(CTRIES.length)
      if @usd_country.index(CTRIES[nextp]).nil? then 
        @players.append(Player.new(name,@users[name].alais,CTRIES[nextp],false,@deck.choosehand))
        @usd_country.push(CTRIES[nextp])

        blat_usr(name,"%WYour country has been chosen for you.  You now rule: %Y#{CTRIES[nextp]}")
        break
      else puts "GD: Collision... try again.. #{nextp}" end 
    end}
end

def startit(u)
  @comp_num = 2
  #blat_usr(u,"***")
  puts "*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!"
  @usd_country.each {|country| puts country}
  puts "*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!"
  blat_usr(u,"%RLet the Carnage Begin!")
  blat_anti(u,"%C#{u} %Whas just started a nuclear war!")
  m_player_intro(@comp_num)

  r_add
  puts "*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!"
  @usd_country.each {|country| puts country}
  puts "*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!"
  @started=true
end

def show_all(u)
  
  blat_usr(u,"%WShow All:")
  for i in 0..@players.len - 1 do
    blat_usr(u," %R#{@players[i].name} %Wcommander of %R#{@players[i].country} %Wwith%R #{@players[i].population} million folks.")
  end
  blat_usr(u,"***")
end

def display_turn(u)
  blat_usr(u,"%WIt's %C#{@players[@turn].name}'s %Wturn, active item is %G#{@deck[@players[@turn].active_weapon].name}%W.")
end

def display_table(u)

  blat_usr(u,"%WPlayers:")
  
  i = 0
  for i in 0..@players.len - 1 do
    if @players[i].dead then
      blat_usr(u," %C#{@players[i].alais}%W, ruler of %Y#{@players[i].country} %R<DESTROYED>")
    else
      blat_usr(u," %C#{@players[i].alais}%W, ruler of %Y#{@players[i].country}%W, armed with a %G#{@deck[@players[i].active_weapon].name}")
    end
  end
  blat_usr(u,"***")
end

def find_incoming(u)
  

  some = false
  j = 0
  
  for j in 0..@players[u].incoming.length - 1
    if @deck[@players[u].incoming[j].weapon].type == CARD_MISSILE then
      some = true
    end
  end
  return some
end

def display_incoming(u)
  
  blat_usr(u,"%WIncoming:")
  

  none = true
  j = 0
  
  for j in 0..@players[u].incoming.length - 1
    if @deck[@players[u].incoming[j].weapon].type == CARD_MISSILE then
      blat_usr(u," %WA %G#{@deck[@players[u].incoming[j].weapon].name}%W with a %G#{@deck[@players[u].incoming[j].card].name} %Wwarhead from %W#{@players[u].incoming[j].country}")
      none = false
    end
  end
  blat_usr(u,"%WThere are no incoming missiles!") if none
  blat_usr(u,"***")
end


def display_stat(u)

  total = (@players[u].population / 10).to_i
  total = 1 if total < 1
  outstring = ""
  total.times {outstring << POP_CHARACTER.chr}
  weapon = "(None)"
  weapon = @deck[@players[u].active_weapon].name if @players[u].active_weapon > 0
  blat_usr(u,"%WYour Stats:")
  blat_usr(u," %WYour population is %C#{@players[u].population} %Wmillion. %R#{outstring}")
  blat_usr(u," %WYour active weapon is %G#{weapon}%W.")
  blat_usr(u," %WYou have nuked %R#{@players[u].kills} %Wmillion people.") 
  blat_usr(u,"***")
end


def find_in_hand(user,card)
  happy = @players[user].hand.index(card)
  if happy != nil then
    #blat_usr(user,"%RFound Card in Your Hand!")
    return happy
  else
    blat_usr(user,"%WYou don't seem to have any of those.  Maybe you moved it to your defensive arsenal?")
    return nil
  end
end

def remove_from_hand(user,card)
  todelete = @players[user].hand.index(card)
  if !todelete.nil? then
    @players[user].hand.slice!(todelete)
  else
    blat("DEBUG:REMOVE_FROM_HAND: Card not found!")
    print("DEBUG:REMOVE_FROM_HAND: Card not found!")   
  end
end

def add_to_defence(user,card)
  @players[user].defence.push(card)
end

def remove_active_weapon(user)
  @players[user].active_weapon = 0
end

def add_to_kills(user,num)
  @players[user].kills = @players[user].kills + num
end

def display_active_weapon(user)
  type = @deck[@players[user].active_weapon].type
  name = @deck[@players[user].active_weapon].name
  case type
  when CARD_MISSILE
    blat_usr(user,"%G#{name}%W in silo, standing by for warhead!")
  when CARD_BOMBER
    blat_usr(user,"%WYour %RBomber%W is standing by for an assault!")
  end
end



def incoming_warning(user)
  bomb_warn	= false
  missile_warn	= false

  j=0
  #blat_usr(user,"#{@players[user].incoming}")
  for j in 0..@players[user].incoming.length - 1
    if @deck[@players[user].incoming[j].weapon].type == CARD_BOMBER and !bomb_warn then
      m_incoming_bomber(user)
      bomb_warn = true
    end
    if @deck[@players[user].incoming[j].weapon].type == CARD_MISSILE and !missile_warn then
      m_incoming_missile(user)
      missile_warn = true
    end
  end
  display_incoming(user) if missile_warn
end

def damage (num)
  total = 0
  num.times{
    result = rand(DIE_SIZE - 1) + 1
    total = total + result}
  return total
end

def percentodds(percent)
  
  roll = rand(99) + 1

  if (roll < percent)
    return true
  else
    return false
  end
end


def comparelevels(attacker, defender)
  
  difference		= [0,20,40,65,100,100]
  delta		= 0
  odds		= 70

  if attacker > defender then
    delta = attacker - defender
    odds -= difference[delta]
  else
    delta = defender - attacker
    odds += difference[delta]
  end

  if odds <= 0 then
    odds = 1
  end
  
  return percentodds(odds);
end

def playerhasdefence (victim,card)
  if @players[victim].defence.index(card) != nil then
    return true
  else 
    return false 
  end
end

def resolvecounterspy(user,from,action)
  
  country_f = @players[from].country
  country_u = @players[user].country
  
  # puts "playerhasdefence: #{playerhasdefence(user, CARD_COUNTERSPY)}"
  if playerhasdefence(user, COUNTERSPY)
    remove_from_defence(user,COUNTERSPY)
    enemyknows = true

    if percentodds(SPYCOUNTERCHANCE)
      m_spycaught_user(user,country_f,action)
      m_spycaught_from(from,country_u)
      return [false,enemyknows]
    else
      m_counterspyfail_user(user,country_f)
      m_counterspyfail_from(from,country_u)
      return [true,enemyknows]
    end
  else
    enemyknows = false
    m_spy_ok(from,country_u)
    return [true,enemyknows]
  end
end


def randomdefencecard(target)
  total = @players[target].defence.length
  if total > 0 then
    return @players[target].defence[rand(total)-1]
  else
    return nil
  end
end

def spyattack(user,from,spymode,enemyknows)
  
  m_spy_report(from)

  case spymode

  when 0
    m_spymode1(from,@players[user].population)  #do the population message

  when 1
    defence = @players[user].defence.length
    m_spymode2(from,defence)    #show how many defence items we've got

    if defence > 0
      snoop = randomdefencecard(user)
      m_spymode2_list(from,@deck[snoop].name) #show a card, any card.
    end

  when 2
    snoop=randomdefencecard(user)
    if snoop != nil
      enemyknows = true
      m_spy_somethingblownup(user,@deck[snoop].name)
      remove_from_defence(user,snoop)
      m_spymode3(from,@deck[snoop].name)
    else
      m_spy_nodefence(from)
    end

  when 3
    if @players[user].active_weapon == NO_CARD
      m_spy_noactive(from)
    else
      enemyknows = true
      item = @deck[@players[user].active_weapon].name
      m_spy_get_active_user(user,item)
      m_spy_get_active_others(user,from,@players[user].country,item)
      m_spy_get_active_from(from,item)
      @players[user].active_weapon  = NO_CARD
      @players[user].bomberfuel = 0;
    end

  end
  m_setting_up_defence(from,@players[user].country) if !enemyknows
end

def handlebombdrop(owner,user,hits)
  
  detonate = true
  fighter = false
  dead = 0

  if playerhasdefence(user,JET) then
    fighter = true
    m_jet_go(user)

    if percentodds(JETCHANCE) then
      m_jet_good(user)
      m_jet_intercept(owner,@players[user].country)
      @players[owner].active_weapon = NO_CARD
      @players[owner].bomberfuel = 0
      detonate = false
    end
  end

  if detonate then
    war
    dead = damage(hits)
    adjective = NUKILL[rand(NUKILL.length - 1)]
    @players[user].population = @players[user].population - dead
    add_to_kills(owner,dead)
    adjective = NUKILL[rand(NUKILL.length - 1)]
    blat_usr(user,"%R*** %WA warhead from %R#{@players[owner].country}%W detonates over your country, #{adjective} %R#{dead} million %Wpeople!")
    blat_anti(user,"%R*** %WA warhead detonates over %R#{@players[user].country}%W, #{adjective} masses of people!")

    if fighter
      if percentodds(50)
        m_jet_good(user)
        m_jet_intercept(owner,@players[user].country)
        @players[owner].active_weapon = NO_CARD
        @players[owner].bomberfuel = 0
      end
    end
  end


  if fighter then
    remove_from_defence(user,JET)
    if @players[owner].active_weapon != NO_CARD then #cheap way to see if the thing was destroyed.
      puts "DEBUG: fighter owner: #{owner}"
      puts "DEBUG: fighter user: #{user}"
      puts "DEBUG: Players alive: #{count_alive}"
      puts "DEBUG: user: #{user}"
      puts "DEBUG: @players.len: #{@players.len}"
      # If @player[user] is nil it means that it is a computer player.
      if !@player.nil?
        m_jet_failed(owner,@player[user].country)
      end
      m_jet_failed_user(user)
    end
  end
end

def war
  @war = true
  @turns_to_peace = TURNS_TO_PEACE
end

def debug_incoming(user,j)
  blat("card: #{@players[user].incoming[j].card}")
  blat("weapon: #{@players[user].incoming[j].weapon}")  
  blat("country: #{@players[user].incoming[j].country}") 
  blat("spy_mode: #{@players[user].incoming[j].spy_mode}")    
  blat("abm: #{@players[user].incoming[j].abm}") 
end

def boom(user)
  if @players[user].population < 1 then 
    @players[user].dead = true 
    if @players[user].population < OVERKILL_LEVEL then
      @players[@turn].overkill += 1
      blat_anti(user,"%R*** MASSIVE OVERKILL!%Y  #{@players[user].country}%W is blown off the face of the planet!")
      blat_usr(user,"%RYOU'RE TOAST!%W  That last nuclear blast tore your country to shreds! Since you have substantially less than zero population, you are out of the game.  Better luck next time!")
    else
      blat_anti(user,"%R*** %Y#{@players[user].country} %Wcollapses into dust.")
      blat_usr(user,"%RYOU'RE GONE!%W With no population to control your machines of war, your country quickly fades out of existence and off the map.  Better luck next time!")
    end
  end
end

def handle_kaboom(user)
  
  if @players[user].incoming.length > 0
    
    for j in 0..@players[user].incoming.length - 1 
      #debug_incoming(user,j)

      intercept = false
      fired_by = @players[user].incoming[j].f_user
      
      case @deck[@players[user].incoming[j].weapon].type
        
      when CARD_MISSILE 
        war
        if @players[user].incoming[j].abm != NO_CARD
          
          missile   = @deck[@players[user].incoming[j].weapon].name
          abm      = @deck[@players[user].incoming[j].abm].name
          country = @players[user].country
          
          intercept = comparelevels(@deck[@players[user].incoming[j].abm].level,@deck[@players[user].incoming[j].card].level)
          
          if intercept then
            blat_usr(fired_by,"%WYour %W#{missile} %Wwas intercepted by %W#{abm}%W launched from %Y#{country}!")
            blat_usr(user,"%WYour %W#{abm}%W intercepted and brought down the incoming %W#{missile}!")
          else
            blat_usr(user,"%WYour %W#{abm}%W launched, but failed to intercept the incoming %W#{missile}!")
          end
        end
        if !intercept then
          hits = @deck[@players[user].incoming[j].card].damage 
          dead = damage(hits)
          adjective = NUKILL[rand(NUKILL.length - 1)]
          blat_usr(user,"%R*** %WA warhead from %Y#{@players[user].incoming[j].country}%W detonates over your country, #{adjective} %R#{dead} million %Wpeople!")
          blat_anti(user,"%R*** %WA warhead detonates over %Y#{@players[user].country}%W, #{adjective} masses of people!")
          @players[user].population = @players[user].population - dead
          add_to_kills(@players[user].incoming[j].f_user,dead)
        end
        
      when CARD_SPY
        spymode = @players[user].incoming[j].spy_mode - 1
        action = SPYMODEDESC[spymode]
        attack,enemyknows = resolvecounterspy(user,fired_by,action)  
        spyattack(user,fired_by,spymode,enemyknows) if attack
        
      when CARD_BOMBER
        puts("user #{user}")
        puts("j: #{j}")
        handlebombdrop(@players[user].incoming[j].f_user,user,@deck[@players[user].incoming[j].card].damage)
      end #of case
      
      boom(user) if count_alive > 1
      puts "DEBUG: Players alive (boom): #{count_alive}"
      if count_alive == 1 then      #the last explosion  won the game!
        m_user_won_nuke(fired_by,@players[fired_by].population)
        m_won_nuke(fired_by,@players[fired_by].country,@players[fired_by].name)
        m_stop
        stop_game
        break
      end
    end
  end
  puts "DEBUG: Kaboom"
  puts "DEBUG: Players alive: #{count_alive}"
  puts "DEBUG: user: #{user}"
  puts "DEBUG: @players.len: #{@players.len}"

  @players[user].incoming.clear
  @complete = true
end

def count_alive
  
  count = 0
  
  for i in 0..@players.len - 1
    count +=1  if @players[i].dead != true
  end
  return count
end


def war_decrement
  if @turns_to_peace > 0 then
    @turns_to_peace = @turns_to_peace - 1 
  else
    blat("%R*** %WSince no nuclear bombs were detonated during the last few turns, the game is officially not in a 'state of war' anymore!  The normal persuasion tactics will now function.") if @war
    @war = false
  end
end

def parse_card (user,instr)
  resultlst = []
  j = 0

  for j in 1..@deck.len - 1 
    x = @deck[j].sname.upcase[instr.upcase]
    resultlst.push(j) if  x != nil
  end
  if resultlst.length < 1 then 
    blat_usr(user,"%RThat item does not exist.")
    return nil
  end
  return resultlst[0] if resultlst.length == 1 
  if resultlst.length > 1 then
    blat_usr(user,"%RYou need to be more specific which item to use.")
    return nil
  end
end

def choose_randomcard
  
  weights 	= 0
  choice 	= 0
  

  # if weights == 0 then
  for j in 0..@randoms.length - 1
    weights += @randoms[j].weight
  end
  choice = rand(weights)

  for i in 0..@randoms.length - 1
    choice -= @randoms[i].weight
    break if choice <= 0
  end
  return i
end



def parse_country(user,instr,suppress)
  puts "!!!!!!!!!!!!Starting parse_country"
  resultlst = []
  j = 0
  
  for j in 0..@players.len - 1 

    x = @players[j].country.upcase[instr.upcase]
    resultlst.push(j) if x != nil
  end
  puts "!!!!!!!!!!DEBUG:resultlst.length: #{resultlst.length}"
  if resultlst.length < 1 then
    blat_usr(user,"%RThere is no country by that name at this table!") if !suppress
    return nil
  end
  if resultlst.length == 1 then
    if @players[resultlst[0]].dead then
      blat_usr(user,"%RThat country has been destroyed!") if !suppress
      return nil
    else
      return resultlst[0] end
  end
  if resultlst.length > 1 then
    blat_usr(user,"%RYou need to be more specific about which country you mean.") if !suppress
    return nil
  end
end

def count_missiles(user,card)

  #count = @players[user].hand.collect{|x| if x == card}
  count = 0
  
  for j in 0..@players[user].hand.length - 1
    count +=1 if @players[user].hand[j] == card
  end
  return count
end


def find_in_defence(user,card)
  happy = @players[user].defence.index(card)
  if happy != nil then
    #blat_usr(user,"%RFound Card in Your Hand!")
    return happy
  else
    blat_usr(user,"%WYou don't have any of those to fire. If you need help, type ?")
    return nil
  end
end

def get_abm(user,parray)
  if parray.length > 2 then
    return nil if parray[1].upcase == "X"
    num = parray[1].to_i
    if (num < 1) or (num > 6) then
      blat_usr(user,"%WTo fire an anti-missile, choose a number from %C1%W to %C6%W.  For help, type ?  To abort firing abm's, enter %CX%W")
      return 0
    end   
    test = (num - 7).abs  #the card numbers are inverted.  nice eh?  This reverses them.
    return test if find_in_defence(user,test) != nil 
    return 0
  end
end 

def get_spy(user,parray)
  puts "DEBUG:I'm in get spy"
  puts "DEBUG:parray.length: #{parray.length}"
  puts "DEBUG:parray[0].upcase: #{parray[1].upcase}" 
  if parray.length > 1 then
    return nil if parray[1].upcase == "X"
    num = parray[1].to_i
    if (num < 1) or (num > 4) then
      blat_usr(user,"%WPlease choose your spy option (%G1,2,3,4,X%W).")
      return 0
    end   
    return num
  end
end

def next_abm(user)
  @abm_in_play +=1
  if @abm_in_play <= @players[user].incoming.length - 1
    puts "DEBUG: @abm_in_play: #{@abm_in_play}"
    puts "DEBUG: @players[user].incoming.length: #{@players[user].incoming.length }" 
    for i in @abm_in_play..@players[user].incoming.length 
      debug_incoming(user,i)
      puts "DEBUG Incoming Loop: i:#{i}"
      if @deck[@players[user].incoming[i].weapon].type != CARD_BOMBER then
        @abm_in_play = i
        return true
        break
      end
    end
  end
  return false
end

def remove_from_defence(user,card)
  todelete = @players[user].defence.index(card)
  if todelete != nil then
    @players[user].defence.slice!(todelete)
  else
    puts "GD: REMOVE_FROM_DEFENCE: Card not found!" end
end

def get_target(user,parray,suppress)

  if parray.length > 0 then
    for j in 0..parray.length - 1
      target = parse_country(user,parray[j],suppress)
      break if target != nil
    end
    puts "!!!!!!!!!!!!!!!Target: #{target}"
    # blat_usr(user,"%W...There is no country by that name at this table!") if target == nil
  end
  return target
end


def parsecmd (inline)        #CAUTION: I didn't know I could write something this crazy... 
  parray 	= Array.new
  parray	= inline.split
  card 	= nil			#Card the User has played
  command	= nil			#The Command the user wants to do
  target 	= nil			#The Target of the command
  


  if parray.length > 0 then
    user = @users.findalais(parray[0]).name 
    u = user
  end
  
  if parray.length > 1 then
    command = parray[1].upcase
  end

  if parray.length > 2 then
    card = parray[2]
  end

  ingame = true if @players[user] != nil and !@players[user].dead
  # puts "GD:ingame: #{ingame}"
  if ingame then
    if @players[@turn].name == user then   #Only allow the current player into this section.  
      case @turn_type
        
      when INPUT_TARGET   #We're getting Target Information
        if command != "TABLE"
          target = get_target(user,parray,false)  #Get target unless the command TABLE is used.
          t_user =@players[target].name if target !=nil
          m_beat_yourself(user) if t_user == user
          m_no_target(user) if target == nil
        end
        
        # puts "target: #{target}" 
        
        if (target !=nil) and (t_user != user) then
          card = @card_in_play 
          command = "USE"
          m_release_mode(user)
        else 
          command = "" if command != "TABLE" and  command != "PASS"   #This prevents any command but TABLE and PASS being used if we are getting TARGETing info.
        end
        
      when INPUT_ABM      #We're getting ABM information
        abm = get_abm(user,parray)
        puts "DEBUG: @abm_in_play #{@abm_in_play}"
        if abm == 0 
          cont = next_abm(user)
        else
          if abm !=nil then
            @players[user].incoming[@abm_in_play].abm = abm
            blat_usr(user,"%W#{@deck[abm].name} %RLaunched...")
            remove_from_defence(user,abm)
            cont = next_abm(user)
          end
        end
        if !cont then 
          @turn_type = INPUT_NORMAL
          m_finished_processing(user)
          @abm_in_play = 0
        else
          display_abm(user,@players[user].defence)
          m_abm_menu(user,@abm_in_play)
        end
        command = ""        #Don't proces any other commands while we are getting ABM information.
        
      when INPUT_SPY
        spy = get_spy(user,parray)
        if spy != nil then
          if spy != 0 then
            @spy_mode = spy
            @turn_type = INPUT_TARGET
            m_spy_target(user) 
            #puts "card in play: #{@card_in_play}"
          end
        else
          command = ""
          m_spy_abort_error(user)
          @turn_type = INPUT_NORMAL
        end
      end #of Case   
    end 
  end

  case command
    
  when "SURRENDER"
    if ingame then
      if @players[@turn].name == user then
        m_surrender(user,@players[user].country)
        m_user_surrender(user)
        @players[user].dead = true
        @complete = true
      else m_surrender_error(user) end
    else m_notingameerror(user) end
    
  when "TURN"
    echo = false
    if ingame then
      display_turn(user)
    else 
      m_notingameerror(user) end
    
  when "NIFTY"
    show_all(user)
    @players[user].hand.push(SPECIAL)
    @players[user].hand.push(COUNTERSPY)
    @players[user].hand.push(SPY)
    @players[user].hand.push(MIRV)
    @players[user].hand.push(BOMBER)
    @players[user].hand.push(JET)

  when "STOCK"
    echo = false
    if ingame then
      display_hand(user,@players[user].hand)
    else m_notingameerror(user) end

  when "DEFENCE"
    echo = false
    if ingame then
      display_defence(user,@players[user].defence)
    else m_notingameerror(user) end

  when "STAT"
    echo = false
    if ingame then
      display_stat(user)
    else m_notingameerror(user) end

  when "TABLE"
    echo = false
    if ingame then
      display_table(user)
    else m_notingameerror(user) end

  when "USE"
    #puts "GD: Use Detected"
    echo = false
    if ingame then
      if @players[@turn].name == user then     #Only the current player can USE something.
        #@complete = true
        if card != nil then
          result = parse_card(user,card.upcase)
          #blat_usr(user,"*** Card Type #{result}") if result != nil
          
          if result != nil then 
            happy = find_in_hand(user,result) 
            if happy != nil then
              card_type = @deck[@players[user].hand[happy]].type
              card_message = @deck[@players[user].hand[happy]].message
              target = get_target(user,parray,true)
              t_user =@players[target].name if target !=nil
              puts "GD: Card type: #{card_type}"

              case card_type
                
              when CARD_PERSUASION
                if target != nil and t_user != user then
                  if !@war or card_message == PERSM3 then
                    hits = @deck[@players[user].hand[happy]].damage 
                    moved = damage(hits)
                    moved == @players[target].population - 1 if moved > @players[target].population 
                    @players[user].population = @players[user].population + moved
                    @players[target].population = @players[target].population - moved
                    remove_from_hand(user,result)

                    case card_message
                    when PERSM1
                      blat(persuasion1_message(@players[user].country,@players[target].country,moved))
                    when PERSM2
                      blat(persuasion2_message(@players[user].country,@players[target].country,moved))
                    when PERSM3
                      blat(persuasion3_message(@players[user].country,@players[target].country,moved))
                    end #of Case card_message
                    handle_kaboom(user)
                    boom(target)
                  else
                    m_bombs_only_error(user) 
                    @turn_type = INPUT_NORMAL
                    @card_in_play = nil
                  end
		else
		  m_persuasion_target(user) 
                  @card_in_play = card
                  @turn_type = INPUT_TARGET
		end # of if target != nil
		
              when CARD_SPY
                if target != nil and @spy_mode != 0 then
                  add_to_incoming(@players[target].name,Incoming_Object.new(result,result,@players[user].country,user,@spy_mode))
                  remove_from_hand(user,result)
                  handle_kaboom(user)
                  m_spy_on_way(user)
		else
		  m_spy_menu(user) 
                  @card_in_play = card
                  @turn_type = INPUT_SPY
		end # of if target != nil
		
              when CARD_RANDOM
                if target != nil and t_user != user then
                  to_play = choose_randomcard
                  #puts "GD:randomcard: #{to_play}"
                  puts "DEBUG: @randoms[to_play].pfnRandom: #{@randoms[to_play].pfnRandom}"
                  case @randoms[to_play].pfnRandom
                    
                  when RANDTHUNDERBOLT
                    if @randoms[to_play].target then
		      m_give_thunderbolt(user,target)
		      @players[target].hand.push(THUNDERBOLT)
                    else
		      m_recieve_thunderbolt(user)
		      @players[user].active_weapon = THUNDERBOLT
                    end
                    
                  when RANDPOPDEATH
                    puts "Population death"
                    hits = rand(3)+1
                    killed = damage(hits)
                    country = @players[user].country
                    @players[target].country if @randoms[to_play].target
                    blat(popdeath_message(country,killed))
                    if @randoms[to_play].target
                      @players[target].population = @players[target].population - killed
                    else
		      @players[user].population = @players[user].population - killed
                    end
                    boom(target)
                    boom(user)
                    
                  when RANDLOSETURN
		    blat(loseturn_message(@players[user].country))
                    
                  when RANDAEGIS
                    puts "Random Aegis"
                    if @randoms[to_play].target then
		      m_give_aegis(user,target)
		      @players[target].defence.push(AEGIS)
                    else
                      m_recieve_aegis(user)
                      @players[user].defence.push(AEGIS)
                    end
                    
                  end #of case
                  
                  remove_from_hand(user,result)		    
                  handle_kaboom(user)
		else
		  m_special_target(user) 
                  @card_in_play = card
                  @turn_type = INPUT_TARGET
                  
		end # of if target != nil
		
              when CARD_POPULATION
                hits = @deck[@players[user].hand[happy]].damage 
                new = damage(hits)
                @players[user].population = @players[user].population + new
                remove_from_hand(user,result)
                blat (population_message(@players[user].country))
                handle_kaboom(user)
                
              when CARD_MISSILE
                @players[user].active_weapon = result
                remove_from_hand(user,result)
                m_opponent_readied_missile(user,@players[user].country,@deck[@players[user].active_weapon].name)
                m_user_readied_missile(user,@deck[@players[user].active_weapon].name)
                handle_kaboom(user)
		
              when CARD_MIRV
                @players[user].active_weapon = result
                remove_from_hand(user,result)
                m_opponent_readied_missile(user,@players[user].country,@deck[@players[user].active_weapon].name)
                m_user_readied_mirv(user,@deck[@players[user].active_weapon].name)
                handle_kaboom(user)

              when CARD_BOMBER
                @players[user].active_weapon = result
                remove_from_hand(user,result)
                m_bomber_ready(user)
                blat_usr(user,"%WYou've readied a %RBomber%W.  Don't forget to put a bunch of warheads on it for the next few turns.")
                @players[user].bomberfuel = MAX_BOMBS
                handle_kaboom(user)	

              when CARD_ABM
                if @players[user].defence.length < MAX_DEFENCE then
                  @players[user].defence.push(result)
                  remove_from_hand(user,result)
                  m_setting_up_defence(user,@players[user].country)
                  m_active_defence(user,@deck[result].name)
                  handle_kaboom(user)
                else
                  m_defence_full_error(user) end
		

              when CARD_FIGHTER
                if @players[user].defence.length < MAX_DEFENCE then
                  @players[user].defence.push(result)
                  remove_from_hand(user,result)
                  m_setting_up_defence(user,@players[user].country)
                  m_active_defence(user,@deck[result].name)
                  handle_kaboom(user)
                else
                  m_defence_full_error(user) end
                
              when CARD_COUNTERSPY
                if @players[user].defence.length < MAX_DEFENCE then
                  @players[user].defence.push(result)
                  remove_from_hand(user,result)
                  m_setting_up_defence(user,@players[user].country)
                  m_active_defence(user,@deck[result].name)
                  handle_kaboom(user)
                else
                  m_defence_full_error(user) end
                
              when CARD_WARHEAD
                active_type = @deck[@players[user].active_weapon].type
                active_level = @deck[@players[user].active_weapon].level
                card_level = @deck[result].level
                
                puts "active_level: #{active_level}"
                puts "card_level: #{card_level}"
                puts "target: #{target}"
                puts "t_user: #{t_user}" 
                
                if active_type == CARD_MISSILE or active_type == CARD_BOMBER or active_type == CARD_MIRV then
                  get_target(user,parray,true) if target == nil 
                  
                  case active_type 
                  when CARD_MISSILE
                    if card_level <= active_level then 
		      if target != nil and t_user != user then
                        m_liftoff(@players[target].name,@deck[@players[user].active_weapon].name,@players[user].country)
                        m_missile_on_way(user,@players[target].country)
                        m_missile_away(user,@players[target].name,@deck[@players[user].active_weapon].name,@players[user].country,@players[target].country)
                        remove_from_hand(user,result)
                        add_to_incoming(@players[target].name,Incoming_Object.new(result,@players[user].active_weapon,@players[user].country,user,nil))
                        remove_active_weapon (user)
                        handle_kaboom(user)
		      else
                        m_missile_target(user)
                        @card_in_play = card
                        @turn_type = INPUT_TARGET
		      end
                    else
                      m_missile_size_error(user)
		      @input_type = INPUT_NORMAL
                    end #of if card_level <= active_level
                    
                  when CARD_MIRV
                    if card_level == 1 then
		      if target != nil and t_user != user then
                        m_liftoff(@players[target].name,@deck[@players[user].active_weapon].name,@players[user].country)
                        m_missile_on_way(user,@players[target].country)
                        m_missile_away(user,@players[target].name,@deck[@players[user].active_weapon].name,@players[user].country,@players[target].country)
                        missiles_to_fire = count_missiles(user,MT12)
                        missiles_to_fire = 10 if missiles_to_fire > 10
                        for j in 1..missiles_to_fire
                          remove_from_hand(user,result)
                          add_to_incoming(@players[target].name,Incoming_Object.new(result,MIRVI,@players[user].country,user,nil))
                        end
                        remove_active_weapon(user)
                        handle_kaboom(user)
		      else
                        m_mirv_target(user)
                        @card_in_play = card
                        @turn_type = INPUT_TARGET
		      end
                    else 
		      m_mirv_to_big(user) 
		      @input_type = INPUT_NORMAL
                    end
                    
                  when CARD_BOMBER
                    if card_level != 6 then 
		      if target != nil and t_user != user then
                        m_liftoff(@players[target].name,@deck[@players[user].active_weapon].name,@players[user].country)
                        m_bomber_on_way(user,@players[target].country)
                        m_missile_away(user,@players[target].name,@deck[@players[user].active_weapon].name,@players[user].country,@players[target].country)
                        remove_from_hand(user,result)
                        add_to_incoming(@players[target].name,Incoming_Object.new(result,@players[user].active_weapon,@players[user].country,user,nil))
                        handle_kaboom(user)
		      else
                        m_bomber_target(user)
                        @card_in_play = card
                        @turn_type = INPUT_TARGET
		      end
                    else
                      m_bomb_to_big(user)
		      @input_type = INPUT_NORMAL
                    end #of if card_level <= active_level

                  end # of Case active_type

                else # of if active_type ==
                  m_throwawayerror(user,@deck[result].name)
                  remove_from_hand(user,result)
                  handle_kaboom(user)
                end

              end #of Case card_type
            end
          end
        end
      else m_notyourturnerror(user) end
    else m_notingameerror(user) end
    
  when "PASS"
    if ingame then
      if @players[@turn].name == user then
        m_passed_turn(user)
        handle_kaboom(user)
        m_release_mode(user)
      else m_notyourturnerror(user) end
    else m_notingameerror(user) end

  when "INCOMING"
    if ingame then
      if @players[@turn].name == user then
        if !@incoming_lock then
          if find_incoming(user) then 
            @incoming_lock = true
            display_abm(user,@players[user].defence)
            m_abm_menu(user,@abm_in_play)
            @turn_type = INPUT_ABM
          else m_nomissilesforabmerror(user) end
        else m_incominglockederror(user) end
      else m_notyourturnerror(user) end
    else m_notingameerror(user) end

  end #of case


end

def bomber_fuel(user)
  if @players[user].bomberfuel > 0 then
    if @deck[@players[user].active_weapon].type = CARD_BOMBER
      @players[user].bomberfuel -=1
      if @players[user].bomberfuel == 0 then
        @players[user].active_weapon = NO_CARD
        m_dead_bomber(user)
      end
    end
  end
end

def update_scores
  for j in 0..@players.len - 1
    won = 0
    won = 1 if @players[j].won == true
    record = AScore.new(@players[j].name,@players[j].kills,@players[j].overkill,won)
    score(record) 
  end
  write_score_file(10)
end

def stop_game
  @started = false
  @channel[@c_num].status = false
  update_scores
end

def last_alive
  
  for i in 0..@players.len - 1
    result = i  if @players[i].dead != true
  end
  return result
end

def check_default_win
  if count_alive == 1 then
    winner = last_alive
    @players[winner].won = true
    m_user_won_default(winner)
    m_won_default(winner,@players[winner].country,@players[winner].name)
    stop_game
    m_stop
  end
end

def do_tick

  if @started
    check_default_win
    if @complete then
      if @turn < @players.len - 1 then 
        @turn = @turn.succ 
      else 
        @turn = 0 
        war_decrement
      end
      u = @players[@turn].name
      puts "TURN: #{u}"
      @channel[@c_num].a_player = u  #The chat server needs to know
      @channel[@c_num].locked = false #The chat server needs to know
      @complete = false
      @incoming_lock = false
      @abm_in_play = 0
      @spy_mode = 0


      if !@players[@turn].virtural and @started then
        if !@players[@turn].dead then
          @turn_time = Time.now.to_i
          @warned = false
          incoming_warning(u)
          bomber_fuel(u)
          @turn_type = INPUT_NORMAL	#What type of input are we getting?
          @card_in_play	= NO_CARD	#The last card played by the current player.

          if @players[@turn].hand.length < MAX_HAND then
            @players[@turn].hand.push(@deck.choosecard)
            m_your_turn(u,@deck[@players[@turn].hand[@players[@turn].hand.length - 1]].name)
          else
            m_max_production(u)
          end
          m_stateofwar(u) if @war
          display_active_weapon(u)
        else
          #blat_usr(u,"%WYou don't get a turn, cause you be %Rdead %Wbaby.") 
          @complete = true
        end
      end
    end
    # puts "GD: Current Turn = #{@players[@turn].name}"

    if @players[@turn].virtural and @players[@turn].dead and @started then
      puts("DEBUG: Skipping #{@players[@turn].name} turn because he's dead.")
      @complete = true
    end
    if @players[@turn].virtural and !@players[@turn].dead and @started then
      bomber_fuel(@turn)
      puts("*****************************************************")
      puts("DEBUG:Player #{@players[@turn].name} is taking his turn.")
      puts("DEBUG:Population: #{@players[@turn].population} million")
      display_hand_v(@turn,@players[@turn].hand)
      puts "DEBUG:@players[@turn].hand.length: #{@players[@turn].hand.length}"
      puts "DEBUG: MAX_HAND: #{MAX_HAND}"
      if @players[@turn].hand.length < MAX_HAND then
        puts "DEBUG: Computer picking a card."
        new = @deck.choosecard
        puts "DEBUG: Computer chooses: #{new}"
        @players[@turn].hand.push(new) 
        puts("DEBUG:Player #{@players[@turn].name} got a new item: #{@deck[new].name}")
      end
      puts("*****************************************************")
      
      secretcard = seekcard(CARD_RANDOM, 0)
      
      if find_incoming(@turn) then 
        puts("DEBUG: Incoming detected.  Firing ABMs.")
        firevirtualABMs
      end
      
      if @deck[@players[@turn].active_weapon] != NO_CARD then
        if @deck[@players[@turn].active_weapon].type == CARD_MIRV then
          played = true
          attemptMIRVwarhead
        end
        if @deck[@players[@turn].active_weapon].type == CARD_MISSILE then
          played = attemptwarhead if countcardtype(CARD_WARHEAD) 
        end
        if @deck[@players[@turn].active_weapon].type == CARD_BOMBER then
          played = attemptbomberwarhead if countcardtype(CARD_WARHEAD)
        end
      end

      if !played and percentodds(15) and countcardtype(CARD_SPY) then
        puts "DEBUG: *** Playing a spy"
        played = true
        playspy
      end

      played = playpersuasion if !played and percentodds(40) and @turnstopeace == 0 


      if !played and percentodds(20) and @players[@turn].hand.index(secretcard) then
        puts "DEBUG: *** Playing a secret"
        playsecret
        played = true
      end

      if !played and percentodds(30) and countcardtype(CARD_POPULATION)
        puts "DEBUG: *** Playing population"
        playpopulation
        played = true
      end

      if !played then
        if countcardtype(CARD_MISSILE) then
          if countcardtype(CARD_ABM) then
            if percentodds(50) then
              puts "DEBUG: Played: #{played}"
              playABM
            else
              playmissile
            end
          else
            playmissile
          end
        else
          if countcardtype(CARD_ABM)
            playABM
          else
            if countcardtype(CARD_POPULATION) then
              played = true
              playpopulation
            end
          end
        end

      end
      
      if @players[@turn].hand.length == MAX_HAND and !played then
        puts("*****************************************************")
        puts "DEBUG: Full hand... replace a random card.  Computer picking a card."
        result=rand(@players[@turn].hand.length - 1)
        puts("DEBUG: Removing card #{result}")
        @players[@turn].hand.slice!(result)
        new = @deck.choosecard
        puts "DEBUG: Computer chooses: #{new}"

        @players[@turn].hand.push(new) 
        puts("DEBUG:Player #{@players[@turn].name} got a new item: #{@deck[new].name}")
        puts("*****************************************************")
      end

      handle_kaboom(@players[@turn].name)
      @complete = true

    end
  end

end
