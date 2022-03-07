class Recipe
  attr_reader :name, :description, :rating

  def initialize(attributes = {})
    # attributes => {name: "Capirinha", description: "Lemon and cachaça", rating: 5}
    @name = attributes[:name]
    @description = attributes[:description]
    @rating = attributes[:rating]
    @done = attributes[:done] || false # defaults to false
  end

  def done?
    @done
  end

  def mark_as_done!
    @done = true
  end
end
