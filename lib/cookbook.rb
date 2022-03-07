require "csv"
require_relative "recipe"

class Cookbook
  def initialize(csv_file)
    @recipes = [] # <--- <Recipe> instances
    @csv_file = csv_file
    load_csv
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_to_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_to_csv
  end

  def all
    return @recipes
  end

  def find(index)
    @recipes[index]
  end

  def persist!
    save_to_csv
  end

  private

  def load_csv
    CSV.foreach(@csv_file) do |row|
      # Type casting
      row[2] = row[2].to_i
      row[3] = row[3] == "true" # "true" == "true" => true / "false" == "true" => false

      @recipes << Recipe.new(
        name: row[0],
        description: row[1],
        rating: row[2],
        done: row[3]
      )
    end
  end

  def save_to_csv
    CSV.open(@csv_file, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.done?]
      end
    end
  end
end
