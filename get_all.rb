require 'nokogiri'
require 'open-uri'
require 'csv'

urls = []

(1..14).each do |num|
  urls.push("https://www.worldfootball.net/players_list/eng-premier-league-2019-2020/nach-mannschaft/#{num}/")
end

players_pages = []
names = []
teams = []
birthdays = []
height_data = []

urls.each do |url|
  doc = Nokogiri::HTML(URI.open(url))
  sleep(1)
  
  doc.css(".standard_tabelle td:nth-child(1) > a").each do |name|
    players_pages.push(name[:href])
    names.push(name.inner_html)
  end

  doc.css(".standard_tabelle td:nth-child(3) > a").each do |team|
    teams.push(team.inner_html)
  end

  doc.css(".standard_tabelle td:nth-child(4)").each do |born|
    birthdays.push(born.inner_html)
  end

  doc.css(".standard_tabelle td:nth-child(5)").each do |height|
    height_data.push(height.inner_html)
  end

end

CSV.open('players_pages.csv', 'w') do |csv|
  csv << players_pages
end

CSV.open('data_1.csv', 'w') do |csv|
  headers = %w(name team born height)
  csv << headers
  names.zip(teams, birthdays, height_data).each { |data| csv << data }
end