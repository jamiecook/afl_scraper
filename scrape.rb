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
GameScore = Struct.new(:team, :q1_score, :q2_score, :q3_score, :q4_score) do
  def total
    q4_score.total
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

def parse_team_score(name, rounds, total)
  GameScore.new(name, *rounds.scan(/(\d+)\.(\d+)/).map { |g,b| Score.new(g.to_i, b.to_i) })
end

def parse_result(result)
  cells = result.css('td')
  t1 = parse_team_score(*cells[0..2].map(&:text))
  t2 = parse_team_score(*cells[4..6].map(&:text))
  Result.new(t1,t2)
end

page = Nokogiri::HTML(open("2014.html"))

puts page.class   # => Nokogirij:HTML::Document
# puts page.css('table#root').map { |t| t['width'] }.size
results = page.xpath('//td[table]')
results.each_cons(2).first(1).map { |round,ladder|
  results = round.children.select { |e| e.name == 'table' }.first(1).map { |e| parse_result(e) }
  # result = parse_results(results)
  # ladder = parse_ladder(ladder)
}

