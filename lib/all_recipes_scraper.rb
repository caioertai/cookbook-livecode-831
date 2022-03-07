require_relative "recipe"
require "open-uri"
require "nokogiri"

class AllRecipesScraper
  def initialize(query)
    @query = query
  end

  def call
    url = "https://www.allrecipes.com/search/results/?search=#{@query}"
    html_string = URI.open(url).read
    doc = Nokogiri::HTML.parse(html_string)

    cards = doc.search(".card__detailsContainer").first(5)
    cards.map do |card|
      name = card.at("h3").text.strip
      description = card.at(".card__summary").text.strip
      rating = 0

      Recipe.new(
        name: name,
        description: description,
        rating: rating
      )
    end
  end
end
