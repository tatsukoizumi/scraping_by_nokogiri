require 'nokogiri'
require 'open-uri'
require 'csv'

urls = CSV.read('players_pages.csv')

details = []

urls.each do |u|
  p details.count
  
  url =  u[0]

  doc = Nokogiri::HTML(URI.open(url))

  prLeagues = []

  doc.css("td > a").each do |a|
    if a.text == "Pr. League"
      prLeagues.push(a)
    end
  end

  tds = []

  if prLeagues.any?
    prLeagues.each { |league| tds.push(league.parent) }
  else
    data = { league: "EPL", season: "19/20", appearances: 0, scores: 0, start_11: 0, to_bench: 0, from_bench: 0, yellow: 0, red_with_2yellow: 0, red: 0 }
    details.push(data)
    next
  end

  valid_table = nil

  tds.each do |td|
    valid_table = td if td.css(" + td > a").text == "2019/2020"
  end

  if valid_table
    season = valid_table.css("+ td > a").text
    appearances = valid_table.css("+ td + td + td > a").text
    scores = valid_table.css("+ td + td + td + td").text
    start_11 = valid_table.css("+ td + td + td + td + td").text
    to_bench = valid_table.css("+ td + td + td + td + td + td").text
    from_bench = valid_table.css("+ td + td + td + td + td + td + td").text
    yellow_cards = valid_table.css("+ td + td + td + td + td + td + td + td").text
    red_cards_with_2yellow = valid_table.css("+ td + td + td + td + td + td + td + td + td").text
    red_cards = valid_table.css("+ td + td + td + td + td + td + td + td + td + td").text
    
    data = { league: "EPL", season: season, appearances: appearances, scores: scores, start_11: start_11, to_bench: to_bench, from_bench: from_bench, yellow: yellow_cards, red_with_2yellow: red_cards_with_2yellow, red: red_cards  }
    details.push(data)
  else
    data = { league: "EPL", season: "19/20", appearances: 0, scores: 0, start_11: 0, to_bench: 0, from_bench: 0, yellow: 0, red_with_2yellow: 0, red: 0 }
    details.push(data)
  end

end

CSV.open('data_2.csv', 'w') do |csv|
  headers = %w(league season appearances score st11 ⤵ ⤴ yellow red(2yellow) red(only) )
  csv << headers
  details.each { |detail| csv << detail.values }
end




