require 'class.rb'
require 'gd_const.rb'

AScore = Struct.new('AScore',:name, :kills, :overkills, :wins) 
class AScore 
  private :initialize
  class << self
    def create(name,  kills, overkills, wins)
      a = self.new
      a.name	= name 
      a.kills 	= kills 
      a.overkills  	= overkills 
      a.wins		= wins 
      return a
    end
  end 
end

class Scores < Listing
  def initialize(console)
    super
  end 

  sync_reader '@mutex',	:name, :kills, :overkills, :wins
  
  def defaultlist
    [AScore.create("blank",0,0,0)]
  end
  
  def loadscores
    loadlist('scores.dat','Score File')
  end

  def [](key) 
    findkey(key.upcase) {|score| score.name.upcase} 
  end 

  def savescores 
    savelist('scores.dat')
  end 

end   #of Class 


def numbertoillions(num)
  
  out = ""
  number = num.to_i

  if  number < 1000 then
    out = "#{number} million"
  else
    if  number < 1000000 then
      whole = number / 1000
      decimal = number % 1000
      decimal = decimal / 10 while (decimal >= 100)
      decimal = 1 if decimal == 10
      if decimal > 0 then
        out = "#{whole}.#{decimal} billion"
      else
        out = "#{whole} billion"
      end
    else
      if number < 1000000000 then
        whole = number / 1000000
        decimal = ((number % 1000000) / 10) * 10
        decimal = decimal / 10 while (decimal >= 100)
        decimal = 1 if decimal == 10
        if decimal > 0 then
          out = "#{whole}.#{decimal} trillion"
        else
          out = "#{whole} trillion"
        end
      else
        whole = number / 1000000000
        decimal = ((number % 1000000000) / 10) * 10
        decimal = decimal / 10 while (decimal >= 100)

        decimal = 1 if decimal == 10

        if decimal > 0 then 
          out = "#{whole}.#{decimal} quadrillion"
        else
          out = "#{whole} quadrillion"
        end
      end
    end
  end
  return(out)
end

def getrankstring(num)
  
  kills = num.to_i

  for i in 0..RANKNAMES.length do

    if kills >= RANKKILLS[i] then 
      break
    end
  end
  return RANKNAMES[i]
end


def write_score_file(num)
  scores = top_scores(num)
  total = num
  total = scores.length - 1 if num > scores.length - 1
  puts scores.length 
  outfile = File.new("#{TEXTPATH}gd_score.txt", File::CREAT|File::TRUNC|File::RDWR, 0644)
  outfile.puts "%CTitle"
  outfile.puts " Commander Name                           %RDamage             Overkills  %GWins"
  outfile.puts " %W---------------------------------------  ------             ---------  ----"
  if scores.length > 0 then
    for i in 0..total do
      outfile.puts "%C#{getrankstring(scores[i].kills)}"
      outfile.puts " #{scores[i].name.ljust(40)} %R#{numbertoillions(scores[i].kills).ljust(18)} #{scores[i].overkills.to_s.ljust(10)} %G#{scores[i].wins}"
      outfile.puts
    end
  else
    outfile.puts "%GNo High Scores.  Why not play a game?"
  end
  outfile.close
end

def top_scores(num)
  sorted_scores = @scores.sort {|x,y| y.kills <=> x.kills}
  sorted_scores.pop #removes blank
  if sorted_scores.length > num then
    sorted.scores.slice!(0..num-1)
  end
  return sorted_scores
end


def update_score(score,u_score)
  score.kills = score.kills + u_score.kills
  score.overkills = score.overkills + u_score.overkills
  score.wins = score.wins + u_score.wins
  @scores.savesscores
end

def add_score(u_score)
  @scores.append(u_score)
  @scores.savescores
end

def score(u_score)
  fetch = @scores[u_score.name]
  if !fetch.nil? then
    update_score(fetch,u_score)
  else
    add_score(u_score)
  end
end


