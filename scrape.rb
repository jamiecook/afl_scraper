require 'nokogiri'

Round = Struct.new(:nr, :results)
Match = Struct.new(:team1_score, :team2_score) do
  def winner
    team1_score.total > team2_score.total ? team1_score.team : team2_score.team
  end
end
class Bye; end

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
# Ladder = [LadderEntry]

def parse_results(results)
  # do something
end

LadderEntry = Struct.new(:team, :played, :points, :ratio)
Ladder = Struct.new(:round, :entries)

def parse_ladder(ladder)
  foo = ladder.css('tr')
  raise "foo" unless foo[0].text =~ /Ladder/
  round = foo[0].text.match(/Rd (\d+) Ladder/)[1].to_i
  entries = foo[1..-1].map { |e| parse_ladder_entry(*e.children) }
  Ladder.new(round, entries)
end

def parse_ladder_entry(team, played, points, ratio)
  LadderEntry.new(team, played.text.to_i, points.text.to_i, ratio.text.to_f)
end

def parse_team_score(name, cumulative_score, total)
  # name -> Sydney, cumulative_score ->  " 4.2  11.5  15.5  22.9 ", total 141
  GameScore.new(name, *cumulative_score.scan(/(\d+)\.(\d+)/).map { |g,b| Score.new(g.to_i, b.to_i) })
end

def parse_match(e)
  cells = e.css('td')
  if cells.size == 2 && cells[1].text =~ /Bye/i
    Bye.new
  else
    t1 = parse_team_score(*cells[0..2].map(&:text))
    t2 = parse_team_score(*cells[4..6].map(&:text))
    Match.new(t1,t2)
  end
end

page = Nokogiri::HTML(open("2014.html"))

puts page.class   # => Nokogirij:HTML::Document
# puts page.css('table#root').map { |t| t['width'] }.size
hack = false
results = page.xpath('//td[table]')
results.each_cons(2).map { |round,ladder|
  hack = !hack
  next unless hack
  p "round -> #{round.children.size}"
  p "ladder -> #{ladder.children.size}"

  results = round.children.select { |e| e.name == 'table' }.map { |e| parse_match(e) }
  ladder = parse_ladder(ladder)
}

