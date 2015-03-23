Round = Struct.new(:nr, :results)

require 'nokogiri'

page = Nokogiri::HTML(open("2014.html"))   
puts page.class   # => Nokogirij:HTML::Document
# puts page.css('table#root').map { |t| t['width'] }.size
results = page.xpath('//td[table]')
results.each_cons(2).first(1).map { |res,ladder|
  p res.class
	p res.css('tr td').size
}

