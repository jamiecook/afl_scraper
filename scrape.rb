require 'nokogiri'

Round = Struct.new(:nr, :results)
Result = Struct.new(:team1_score, :team2_score) do
  def winner
    team1_score.total > team2_score.total ? team1_score.team : team2_score.team
  end
end
Score = Struct.new(:goals, :behinds) do
  def total
    goals * 6 + behinds
  end
end
GameScore = Struct.new(:q1_score, :q2_score, :q3_score, :q4_score) do 
  def total
    [q1_score, q2_score, q3_score, q4_score].sum(&:total)
  end
end
LadderEntry = Struct.new(:team, :wins, :points, :ratio)
# Ladder = [LadderEntry]

def parse_results(results) 
  # do something
end

def parse_ladder(ladder) 
  # do something
end

page = Nokogiri::HTML(open("2014.html"))   
puts page.class   # => Nokogiri:HTML::Document



results = page.xpath('//td[table]') # 46 of these
results.each_cons(2).first(1).map { |results,ladder|
  result = parse_results(results)
  ladder = parse_ladder(ladder)
  p results.class
  p results.css('tr td').size
  
}

