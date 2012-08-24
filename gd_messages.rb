##############################################
#											
#   gd_messages.rb --Messages Code File for Global Destruction.		
#   (C) Copyright 1992, High Velocity Software, Inc.                                     
#   (C) Copyright 2004, Fly-By-Night Software (Ruby Version)                        
#                                                                                                            
############################################## 

def population_message(country)

  messages = ["%G***%W Researchers in fertility make a record breakthrough!  Millions of people are born to a wonderful life in %Y%s%W!",
		    "%G***%W Visitors from the planet Neptune land in %Y%s%W!  The government intervenes and destroys their spacecraft, effectively adding them to the population!",
		    "%G***%W Laboratory technicians in %Y%s%W perfect a clever cloning technique!  Within days, millions of citizens are duplicated and put to work building nuclear hardware.",
		    "%G***%W Dr. Ruth publishes her latest book in %Y%s%W, complete with pop-up pictures.  Nine months later there is a population explosion!",
		    "%G***%W A weird dose of powerful cosmic radiation strikes %Y%s%W, and millions of zombies rise from the grave to join the population!",
		    "%G***%W From deep within the hills of %Y%s%W, millions of previously uncounted hillbillies pour into the cities, and are added to the population!",
		    "%G***%W A mad scientist in %Y%s%W discovers a way to bring department store mannequins to life, turning millions of naked people loose into the streets.",
		    "%G***%W While unsealing a gigantic time capsule discovered under the capital of %Y%s%W, scientists discover millions of people inside in suspended animation, and revive them!",
		    "%G***%W In a mass education campaign, %Y%s%W makes millions of chimpanzees smart enough to qualify as citizens, adding them to the population!",
		    "%G***%W All of the people who ever disappeared into the Bermuda Triangle suddenly reappear, and decide to live in %Y%s%W!",
		    "%G***%W %Y%s%W develops a new form of math!  When they use it to recount their population, they discover they have millions more citizens than originally thought!",
		    "%G***%W The citizens of %Y%s%W go on a wild caffeine spree.  They ingest so much cola and coffee that they begin to shake violently.  Millions of people shake themselves so hard that they actually split into two separate people!",
		    "%G***%W After studying the constitution of %Y%s%W, a scholar discovers that television game show hosts DO count as people!  When the population count is adjusted, they discover it has risen by several million!",
		    "%G***%W The final game of the NBA Championship is held in %Y%s%W!  Billions of people gather from around the globe to watch Charles Barkley and the Suns pulverize the opposition.  After the game, many millions of people who bet against Phoenix are stuck homeless and have to stay!"]

   
   which = rand(messages.length - 1)
   return messages[which].gsub!("%s",country)
  end 

def persuasion1_message(country,country2,number)

 messages = ["%G***%W A vision of Elvis appears above the skies of %Y%s%W and %G%u million%W people follow him to his reputed home in %Y%d%W.",
		   "%G***%W After receiving a promotion for free pizza and alcoholic beverages, the population of %Y%s%W rushes the borders!  By the time the government stops the broadcasts, %G%u million%W people have emigrated to %Y%d%W!",
		   "%G***%W A mysterious advertising campaign floods the radio waves of %Y%s%W, urging %G%u million%W people to seek %Y%d%W, home of the sacred Giant Pickle.",
		   "%G***%W When rumors surface that Roseanne Barr is running around naked in %Y%s%W, %G%u million%W people flee screaming into the safety of %Y%d%W.",
		   "%G***%W Word of newly created specially flavored, vitamin rich, extra slurpable form of jello spreads throughout %Y%s%W, causing %G%u million%W jelloites toquest to %Y%d%W in search of this delicacy.",
		   "%G***%W Frankenstein's monster advertises in the newspaper romance ads in %Y%s%W. %G%u million%W love-starved women move to %Y%d%W to be with their green and grunting Romeo!",
		   "%G***%W For no particular reason whatsoever, people get really sick of %Y%s%W.  %G%u million%W people get up and move into %Y%d%W.",
		   "%G***%W A sneezing epidemic hits %Y%s%W!  %G%u million%W people flee into %Y%d%W, which is world renowned for their softer kleenex.",
		   "%G***%W Floods ravage %Y%s%W, washing %G%u million%W people out of the country.  They finally wash ashore in %Y%d%W, and are so happy to be on dry land again, they settle down and live there.",
		   "%G***%W An elite group of visionary burrowologists from %Y%s%W decideto dig a hole through the entire Earth!  They are almost done when the hole begins to collapse, and %G%u million%W people fall allthe way through the planet and end up in %Y%s%W.",
		   "%G***%W AVALANCHE!  Mount Rockaloosea in %Y%s%W suddenly begins to collapse.  The great city of Bigburg (founded 1897, population %G%u million%W) slides from its majestic perch atop the mountain and comes to rest in the heart of %Y%d%W.",
		   "%G***%W One shiny and happy morning in %Y%s%W, %G%u million%W little children toddle out of bed, wiping Mr. Sandman from their innocent eyes, only to discover a trail of breadcrumbs leading out into the distance.  The sweet little cherubs follow the trail to %Y%d%W where they are locked into cold medical labs and mutated into hard-working, slightly grumpy slaves."]
		   
   which = rand(messages.length - 1)
   outmsg = messages[which].gsub("%d",country)
   outmsg = outmsg.gsub("%s",country2)
   return outmsg.gsub!("%u",number.to_s)
  end 


def persuasion2_message(country,country2,number)

 messages = ["%G***%W After receiving a state of the country address from %Y%d%W, %G%u million%W people rush for the borders, abandoning %Y%s%W for better tax breaks!",
		   "%G***%W With bombers disguised as banana transport planes, %Y%d%W distributes pamphlets to %G%u million%W people in %Y%s%W, inviting them to a complementary cheeseburger and fries.  When the population tries to return, they are detained and held by the government!",
		   "%G***%W Misled by rumors of a mysterious 'Bermuda Rhombus', masses of people board jets to satisfy their gnawing curiosity.  Within days, %Y%d%W has %G%u million%W people lured away from their homeland of %Y%s%W.",
		   "%G***%W %Y%d%W gets a monopoly on Gilligan's Island reruns, causing %G%u million%W devoted fans leave %Y%s%W so they can see their favorite show!",
		   "%G***%W Hearing of miraculous, foot-soothing breakthroughs in tube sock soccurring in %Y%d%W, %G%u million%W corn and bunion sufferers flee %Y%s%W in search of comfort!",
		   "%G***%W Using a super-huge vacuum, the leaders of %Y%d%W suck %G%u million%W very surprised people right out of %Y%s%W and into their country!",
		   "%G***%W The national lottery of %Y%d%W grows to an unbelievable jackpot! %G%u million%W people swarm into the country from %Y%s%W to buy tickets, only to find they love it so much they want to stay!",
		   "%G***%W Those clever scientists from %Y%d%W develop a magnet gun of previously unimaginable power.  When they activate it, %G%u million%W people are held captive by their metal belt buckles and drawn helplessly out of %Y%s%W.",
		   "%G***%W A rare sighting of the Red Breasted Rubbalulum bird in %Y%d%W (previously thought to be extinct thanks to global warming, heavy pollution, and rap music) creates frenzy and rejoicing in the bird community.  %G%u million%W ornithologists leave %Y%s%W in search of this wondrous bird."]
		   
   which = rand(messages.length - 1)
   outmsg = messages[which].gsub("%d",country)
   outmsg = outmsg.gsub("%s",country2)
   return outmsg.gsub!("%u",number.to_s)
  end 

def persuasion3_message(country,country2,number)

 messages = ["%G***%W A huge green beam emanates from %Y%d%W, bathing the population of %Y%s%W in its unnatural emerald glow.  Moving like zombies, %G%u million%W people dutifully march from their homes to the beam's source.",
		   "%G***%W In a tricky political move, %Y%d%W announces a press conference with God at its national capital.  %Y%s%W sends an envoy of %G%u million%W people, all of whom are arrested upon arrival.",
		   "%G***%W The yearly Frungy championship is held in %Y%d%W!  The leading team from %Y%s%W is sent, as well as %G%u million%W fans.  All of them are convinced tobecome residents by the smooth-talking referees.",
		   "%G***%W The scientists of %Y%d%W ship cases of special cat-brainwashing cat food into %Y%s%W, causing the %G%u million%W cats that eat it (and their loyal owners) to defect!",
		   "%G***%W Hugh Digitopolis, the great thumb-wrestling champion, defects to %Y%d%W from his homeland of %Y%s%W.  %G%u million%W fans follow him on his path to glory!",
		   "%G***%W A clever artist in %Y%d%W with too much time on her hands faxes a mysterious and authentic looking treasure map all over %Y%s%W! %G%u million%W people, with dreams of wealth and power filling their heads, follow the map... and are rather surprised to learn that they are not allowed to return homeland afterwards!",
		   "%G***%W In the dark of the night, a commando postal hit squad from %Y%d%W invades %Y%s%W and puts postage stamps on %G%u million%W peoples foreheads.  The next day, all those people are mailed out of the country, where they decide to stay.",
		   "%G***%W In a wild and crazy promotional idea, %Y%d%W ships helium-laced packs of bubble gum to people all across %Y%s%W!  %G%u million%W people float into the air while blowing bubbles, and come to rest you-know-where..."]

 
    which = rand(messages.length - 1)
   outmsg = messages[which].gsub("%d",country)
   outmsg = outmsg.gsub("%s",country2)
   return outmsg.gsub!("%u",number.to_s)
  end 
  
def popdeath_message(country,number)

 messages = ["%G***%W During a political announcement, the president of %Y%d%W, begins playing a saxophone. %G%u million%W citizens listening to the program via car stereo are killed in a series of massive crashes.",
		   "%G***%W After a record-strength earthquake, a small section of %Y%d%W slides into the sea! %Y%s%W sends an envoy of %G%u million%W are sent to watery graves.",
		   "%G***%W A meat-packing company accidentally delivers yak steaks to a popular fast-food chain in %Y%d%W!  , who then proceeds to undercook the already foul meat.  As a result, %G%u million%W citizens turn green and die.",
		   "%G***%W Riot!  During a mid-season frungy match-up, a number of players are ejected from the game for spitting and grunging.  Although the home team of %Y%d%W emerges victorious, %G%u million%W fans die in the combat!",
		   "%G***%W Cartoon characters run rampant in %Y%d%W.  %G%u million%W people are erased by the maniacal ink-terrorists before order can be restored!",
		   "%G***%W Trying futily to find something to watch on television in %Y%d%W  %G%u million%W people die of sheer boredom.",
		   "%G***%W Happy-Hole Doughnuts make their debut in %Y%d%W  These morsels are SO delicious that %G%u million%W people eat so many that they explode!.",
		   "%G***%W A shipping truck explodes while delivering to a fast-food chain in %Y%d%W  %G%u million%W people tragically die in the catastrophic potato accident.",
		   "%G***%W At a huge philosophy convention in %Y%d%W, one of the speakers successfully proves that all the people listening to him do not really exist.  %G%u million%W people tuning into his speech on television immediately vanish!",
		   "%G***%W Confusion runs rampant in %Y%d%W.  %G%u million%W people are so distraught that they cannot understand the rules of the game of frungy that they all sell their bodies to science, commit suicide, and donate the money to the Frungy Fund for Flexible Foundlings."]
 
    which = rand(messages.length - 1)
   outmsg = messages[which].gsub("%d",country)
 
   return outmsg.gsub!("%u",number.to_s)
  end 
  
def loseturn_message(country)

 messages = ["%G***%W Presidential election in %Y%d%W! Countless voters hit the streets to cast their ballots, thousands of computers are used to tally the results, and the same old militant regime stays in power.",
		   "%G***%W Nothing of interest happens in %Y%d%W so the turn passes to the country.",
		   "%G*** %Y%d%W is named Acorn Grower of the Year, and given an honorary oak leaf made of tin foil.",
		   "%G*** %Y%d%W is momentarily frozen in a glacier, preventing anything really useful from happening."]
 
 which = rand(messages.length - 1)
 outmsg = messages[which].gsub("%d",country)
 
   return outmsg
  end 
  
  def m_alreadystarting(u)
  blat_usr(u,"%GA game is already starting.  Please wait.")
 end
 
  def m_notingameerror(u)
  blat_usr(u,"%GYou're not playing!  Enter ? for help.")
 end

 def m_nomissilesforabmerror(u)
  blat_usr(u,"%WThere are no incoming missles!")
 end
 
def m_incominglockederror(u)
  blat_usr(u,"%WThere is no margin for error in Nuclear Combat!")
 end
 
 def m_spy_abort_error(u)
  @channel[@c_num].locked = false
  blat_usr(u,"%GYou're spy's mission has been aborted (coward)!")
 end
 
 def m_throwawayerror(u,item)
  blat_usr(u,"%WOk, you played the %G#{item}%W  Remember, if you want to launch a warhead,you have to use a missile or bomber first!  If try to use a warheadwithout a missile or bomber, the warhead is thrown away.  Enter 'HELP MISSILES' for exact info on using missiles, or 'HELP JETS' for info onusing bombers and jet fighters.")
 end

 def m_notyourturnerror(u)
  blat_usr(u,"%GWait for your turn to play!  Sheeeesh!")
 end

 def m_bombs_only_error(u)
  blat_usr(u,"%WSorry, but the world is in too much of a state of turmoil for your persuasion techniques to have any effectiveness!  Nothing short of brainwashing (or nuclear bombs) will reach the population right now.")
 end

 def m_missile_target(u)
  @channel[@c_num].locked = true
  blat_usr(u,"%WThe missile is armed!  To launch the missile, enter the country name of the target at the next prompt.  For a list of players and countries, enter '%GTABLE%W'.  Note that you can enter a partial name, such as 'Las' for 'Las Vegas'.")
 end

 def m_mirv_target(u)
  @channel[@c_num].locked = true
  blat_usr(u,"%WEnter the country name of the target at the next prompt.  If you need a list of available targets, enter '%GTABLE%W'.")
 end
 
 def m_passed_turn(u)
  blat_usr(u,"%WOk, you passed your turn.") 
 end
 
 def m_your_turn(u,weapon)
  blat_usr(u,"%WYour turn!  Your country produces %G#{weapon}")
 end
 
 def m_abm_menu(user,num)
  @channel[@c_num].locked = true
  blat_usr(user,"%WSelecting ABM to fire at incoming %G#{@deck[@players[user].incoming[num].weapon].name}/#{@deck[@players[user].incoming[num].card].name} %Wfrom %Y#{@players[user].country}.")
  blat_usr(user,"%WWhich ABM to fire? (1-6, or X for no ABM).")
 end
 
 def m_max_production(u)
  blat_usr(u,"%WYour turn!  Your country's production is at maximum.")
 end
 
 def m_stateofwar(u)
  blat_usr(u,"%G*** %WThe world is in a state of %Rwar%W.")
 end
  
 def m_bomb_to_big(u)
  blat_usr(u,"%WYou can't fit a warhead that big on a bomber!")
 end
 
 def m_bomber_on_way(u,country)
  blat_usr(u,"%WYour bomber is en route to %Y#{country}%W!")
 end
 
 def m_missile_on_way(u,country)
  blat_usr(u,"%WMissile en route to %Y#{country}%W!")
 end
 
 def m_missile_away(u,u2,weapon,country,target)
  blat_anti2(u,u2,"%G***%W A%G #{weapon}%W lifts off from %Y#{country}%W heading towards #{target}!")
 end
 
 def m_release_mode(u)
  @channel[@c_num].locked = false
 end
 
 def m_bomber_target(u)
  @channel[@c_num].locked = true
  blat_usr(u,"%WThe warhead is in place on your bomber!  To drop the bomb, enter the country name of the target at the next prompt.  For a list of players and countries, enter '%GTABLE%W'.")
 end
 
 def m_persuasion_target(u)
  @channel[@c_num].locked = true
  blat_usr(u,"%WYour army of advertising executives and spies is ready!  To begin, enter the country name of the target at the next prompt.  For a list of players and countries, enter '%GTABLE%W'.")
 end
 
 def m_special_target(u)
  @channel[@c_num].locked = true
  blat_usr(u,"%WWell, to use this special item you have to pick someone to use it on! Enter the country name of the target at the next prompt.  For a list of players and countries, enter '%GTABLE%W'.  Note that you can enter a partial name, such as 'Anta' for 'Antarctica'.")
 end
 
def m_spy_target(u)
 @channel[@c_num].locked = true
 blat_usr(u,"%WAll right.  Now that you've chosen the action you want your spy to perform, you must choose the target for your espionage.  Enter the country name of the target at the next prompt.  For a list of players and countries, enter '%GTABLE%W'.")
end

def m_defence_full_error(u)
  blat_usr(user,"%WSorry, but your active defense arsenal is full!" ) 
 end

def m_finished_processing(u)
  @channel[@c_num].locked = false
  blat_usr(u,"%WFinished processing incoming missiles!  Returning to normal gameplay. Don't forget you can still use an item this turn!  Enter '%GHELP TURN%W' if you need help with your options.")
 end

 def m_give_thunderbolt(u,target)
  country = @players[u].country
  t_country = @players[target].country
  blat_usr(u,"%WDue to a clerical error, your production lines accidentally shipped a newly constructed %WThunderbolt VI%W to %G#{t_country}%W... Oops!")
  blat_anti2(u,target,"%G***#{t_country}%W loads a shiny new %GThunderbolt VI%W onto a silo from a secret weapons cache!")
  blat_usr(target,"%G***%W Due to a shipping error in %Y#{country}%W, you have just been sent a brand new %WThunderbolt VI%Wvia postal carrier!  Seizing the opportune moment, your general loads the missile onto a silo and signs the return receipt!")
 end

 def m_give_thunderbolt_v(u,target)
  country = @players[u].country
  t_country = @players[target].country
  blat_anti2(u,target,"%G***#{t_country}%W loads a shiny new %GThunderbolt VI%W onto a silo from a secret weapons cache!")
  blat_usr(target,"%G***%W Due to a shipping error in %Y#{country}%W, you have just been sent a brand new %WThunderbolt VI%Wvia postal carrier!  Seizing the opportune moment, your general loads the missile onto a silo and signs the return receipt!")
 end
 
def m_recieve_thunderbolt(u)
 blat_usr(u,"%WWhile cleaning out a closet, your next-in-command discovers an old pile of missile parts!  Amazingly enough, they are assembled into a shiny new %GThunderbolt VI%W, which is then readied in a silo!")
end

def m_spy_menu(u)
 @channel[@c_num].locked = true
 blat_usr(u,"%WIn order to use your spy, you must choose what action you wish the spy to perform.  Your choices are:")
 blat_usr(u," %G1- %WGet information about an enemy's population.")
 blat_usr(u," %G2- %WSpy on an enemy's defensive arsenal.")
 blat_usr(u," %G3- %WAttempt to sabotage a nation's defense.")
 blat_usr(u," %G4- %WAttempt to destroy your enemy's missile or bomber.")
 blat_usr(u," %GX- %WAbort using the spy.")
 blat_usr(u,"***")
end

def m_give_aegis(u,target)
  country = @players[u].country
  t_country = @players[target].country
  blat_usr(u,"%WA diplomat from your country sends an %GAegis VI%W anti-missile to a bordering country as a token of good faith.  Unfortunately, the box is mislabeled and the ABM arrives in %W#{t_country}%W instead!")
  blat_anti2(u,target,"%G***#{t_country}%W moves an extremely large anti-missile to its defensive arsenal.")
  blat_usr(target,"%G***%W A brand new %GAegis VI%W has just been moved into your defensive arsenal, compliments of the staff of %Y#{country}%W, Apparently, the shipment was meant for the arms dealer next door.")
 end
 
 def m_give_aegis_v(u,target)
  country = @players[u].country
  t_country = @players[target].country
  blat_anti2(u,target,"%G***#{target}%W moves an extremely large anti-missile to its defensive arsenal.")
  blat_usr(target,"%G***%W A brand new %GAegis VI%W has just been moved into your defensive arsenal, compliments of the staff of %Y#{country}%W, Apparently, the shipment was meant for the arms dealer next door.")
 end

 def m_recieve_aegis(u)
 blat_usr(u," %WA child prodigy in your country manages to make an %GAegis VI%W  anti-missile from an old television, a toothpaste tube, some tin foil,and a large rubber band!  You pat the industrious young lad on the head and put the missile in your defensive arsenal.")
 end

def m_spycaught_user(u,country,action)
 blat_usr(u,"%G***%W A spy from %Y#{country}%W has just been apprehended!  The information presented by your %WCounterspy%W indicates the spy was trying to #{action}.")
end

def m_spycaught_from(u,country)
 blat_usr(u,"%WThe spy was caught by a %WCounterspy %Win %Y#{country}%W!  The mission is a total loss!")
end

def m_counterspyfail_user(u,country)
 blat_usr(u,"%G***%W A spy from %Y#{country}%W has entered the country and managed to kill your %WCounterspy%W!")
end

def m_counterspyfail_from(u,country)
 blat_usr(u,"%WThe spy encountered and killed a %WCounterspy%W in %Y#{country}%W!")
end

def m_spy_ok(u,country)
 blat_usr(u,"%WThe spy has successfully reached the capital of %Y#{country}%W!")
end

def m_spy_report(u)
 blat_usr(u,"%G*** TOP SECRET ***%W  Espionage results from spy. %G*** TOP SECRET ***")
end

def m_spymode1(u,population)
 blat_usr(u," %WPopulation: %G #{population} million")
end

def m_spymode2(u,defence)
 blat_usr(u, "%WItems in defence: %G#{defence}")
end

def m_spymode2_list(u,defence)
 blat_usr(u," %WIncluding: %G#{defence}")
end

def m_spy_somethingblownup(u,item)
 blat_usr(u,"%G***%G #{item} %Wfrom your defense has just been destroyed by a spy!")
end

def m_spymode3(u,item)
 blat_usr(u," %WDestroyed defence: %G#{item}")
end

def m_spy_nodefence(u)
 blat_usr(u,"%G No defense present to sabotage!")
end

def m_spy_noactive(u)
 blat_usr(u,"%G No active item to sabotage!")
end

def m_spy_on_way(u)
 blat_usr(u,"%W Your spy slinks off to perform his mission...")
end

def m_spy_get_active_user(u,item)
 blat_usr(u,"%G***%W The %G#{item}%W that was ready has just been sabotaged by a spy!")
end

def m_spy_get_active_others(u,from,country,item)
 blat_anti2(u,from,"%G***%Y#{country}'s %G#{item}%W just exploded!")
end

def m_spy_get_active_from(u,item)
 blat_usr(u,"%W Destroyed active item: %G#{item}")
end

def m_setting_up_defence(u,country)
 blat_anti(u,"%G*** %Y#{country}%W is setting up its defences.")
end

def m_beat_yourself(u)
 blat_usr(u,"%GYou can't attack yourself (even though you might want to).")
end

def m_no_target(u)
 blat_usr(u,"%GYou must enter a target.  For a list of targets, type %G'TABLE'%W.")
end

def m_opponent_readied_missile(u,country,item)
 blat_anti(u,"%G***%Y #{country} %Whas loaded a missile into a silo: %G#{item}%W.")
end

def m_user_readied_missile(u,weapon)
 blat_usr(u,"%WYou've readied the %G#{weapon}%W.  Don't forget to fire a warhead next time %Wyour turn comes around!")
end

def m_user_readied_mirv(u,weapon)
 blat_usr(u,"%WYou've readied the %G#{weapon}%W.  When you are ready to fire the missile, put a %G12 mt I%W warhead on it!")
end

def m_mirv_to_big(u)
 blat_usr(u,"%WYou can only put a %Gm12 mt I%W warhead on an %GMIRV Missile%W!  Once you use a %G12 mt I%W, up to %Gten%G of your remaining %G12 mt I%W warheads will be automatically mounted on the %GMIRV Missile%W.")
end

def m_dead_bomber(u)
 blat_usr(u,"%G***%W Your %GBomber%W has just run out of fuel and crashed!")
end

def m_jet_go(u)
 blat_usr(u,"%G***%W Scrambling %GJet Fighter%W on intercept course!")
end

def m_jet_good(u)
 blat_usr(u,"%G***%W The bomber was shot down!")
end

def m_jet_intercept(u,country)
 blat_usr(u,"%G***%W Your bomber was intercepted and shot down by a %GJet Fighter%W over %Y#{country}%W!")
end

def m_jet_failed(u,country)
 blat_usr(u,"%G***%W A %GJet Fighter%W from %Y#{country}%W was launched, but failed to intercept the bomber!")
end

def m_jet_failed_user(u)
 blat_usr(u,"%G***%W Your %GJet Fighter%W was unable to intercept the bomber!")
end

def m_surrender(u,country)
 blat_anti(u,"%G*** %Y#{country}%W has just been bought out by a group of software vendors!.")
end

def m_user_surrender(u)
 blat_usr(u,"%WHanging your head in defeat, you surrender control of your country to the right-wing extremists who immediately sell it off to foreign investors.")
end

def m_surrender_error(u)
 blat_usr(u,"%GYou can only surrender during your turn, stoopid.")
end

def m_user_won_nuke(u,population)
 blat_usr(u,"%G*** YOU WON!%W  Through skill, deceit, and certainly a lot of luck, you managed to slaughter all of your competitors-in-arms!  Under your skillful command, your country's military managed to incinerate a grand total of %G#{population} enemy population!  Congratulations!")
end

def m_won_nuke(u,country,name)
 blat_anti(u,"%G*** %Y#{country}%W has just assumed control of the (glowing) world!  Congratulations to the wily %C#{name}%W, skillfully guiding the country to strategic victory!")
end

def m_user_won_default(u)
 blat_usr(u,"%G*** %W Well, since everybody else seems to have died, given up, or gone away, I guess you win the game.  Congratulations for a bloodless, albeit boring, victory.")
end

def m_won_default(u,country,name)
 blat_anti(u,"%G*** %Y#{country} %Whas just assumed control of the world, since all other competitors seem to be incapable of contesting the victory.  Congratulations to the clever %C#{name}%W, managing victory through inaction.")
end

def m_active_defence(u,item)
 blat_usr(u,"%WThe %G#{item}%W is now in your active defense arsenal.")
end

def m_missile_size_error(u)
 blat_usr(u,"%WYou can't fit a bomb that big on such a puny missile!")
end

def m_liftoff(u,item,country)
 blat_usr(u,"%G***%W A%G #{item} %Wlifts off from %Y#{country}%W, heading towards your country!")
end

def m_hangup(u,country)
 blat_anti(u,"%G***%W Leaderless, %Y#{country}%W collapses into radioactive dust.")
end

def m_warning(u)
 blat_usr(u,"%R***%W Hey... it's still your turn.  You'd better play soon or you will be ejected for delay of destruction!  If you need help, enter '%GHELP TURN%W' for your options.")
end

def m_incoming_bomber(u)
 blat_usr(u,"%R*** WARNING!  WARNING!%W Incoming bomber aircraft on radar!")
end

def m_incoming_missile(u)
 blat_usr(u,"%R*** Alert!  Alert!%W  Incoming missiles on radar!")
end

def m_kickoff_user(u)
 blat_usr(u,"%R***%W You are now being ejected for delaying the game!  Next time you start a game, make sure you're going to be around long enough to finish it!")
end

def m_kickoff(u,country)
 blat_anti(u,"%G*** %Y#{country}%W has just dissolved in a massive revolution!")
end

def m_intro
 blat("***%W Global Destruction ver #{GD_VERSION}")
end

def m_stop
 #blat("***GAME END")
end

def m_bomber_ready(user)
 blat_anti(user,"%G*** %Y#{@players[user].country}%W is fueling up a %GBomber%W.")
end
 
def m_notenoughplayers(min,current)
 min_play = "player"; cur_play = "player"
 min_play = "players" if min > 1
 cur_play = "players" if current > 1
 blat("%G***%W Global Destruction ver #{GD_VERSION}")
 blat("%G***%W You must have #{min} #{min_play} to start a game.")
 blat("%G***%W You only have #{current} #{cur_play}.")
end

def m_player_intro(number)
   p_out = "player"
   isare = "is"
   if number > 1 or number == 0
    p_out = "players" 
    isare = "are"
   end

   blat("%WThere #{isare} %G#{number} %WA.I. #{p_out} in this game")
end