require "open-uri"
require "nokogiri"
require "pry-byebug"
require_relative "recipe"

puts "What do you want to search for?"
user_query = gets.chomp
url = "https://www.allrecipes.com/search/results/?search=#{user_query}"

html_string = URI.open(url).read
doc = Nokogiri::HTML.parse(html_string)

cards = doc.search(".card__detailsContainer")
recipes = cards.map do |card|
  name = card.at("h3").text.strip
  description = card.at(".card__summary").text.strip

  Recipe.new(name, description)
end

p recipes

puts "End"
