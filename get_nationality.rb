require 'nokogiri'
require 'open-uri'
require 'csv'

urls = CSV.read('players_pages.csv')

places = []
nationalities = []

urls.each do |u|

  url = u[0]

  doc = Nokogiri::HTML(URI.open(url))

  doc.css(".sidebar td > b").each do |b|
    
    if b.text == "Place of birth:"
      td = b.parent
      place_of_birth = td.css("+ td").text.strip
      places.push(place_of_birth)
    end

    if b.text == "Nationality:"
      td = b.parent
      nationality = td.css("+ td").text.strip
      nationalities.push(nationality)
    end

  end

  p nationalities.count

end

p "done!!"
p places
p '----------------------------------------------------------------------------------------------'
p nationalities

