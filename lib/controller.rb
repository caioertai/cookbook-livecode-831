require_relative "view"
require_relative "recipe"
require_relative "all_recipes_scraper"

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  # USER ACTIONS

  def list
    display_recipes
  end

  def create
    # 1. Ask user for a name (view)
    name = @view.ask_user_for("name")
    # 2. Ask user for a description (view)
    description = @view.ask_user_for("description")
    # 2. Ask user for a rating (view)
    rating = @view.ask_user_for("rating").to_i
    # 3. Create recipe (model)
    recipe = Recipe.new(
      name: name,
      description: description,
      rating: rating
    )
    # 4. Store in cookbook (repo)
    @cookbook.add_recipe(recipe)
    # 5. Display
    display_recipes
  end

  def destroy
    # 1. Display recipes
    display_recipes
    # 2. Ask user for index (view)
    index = @view.ask_user_for_index
    # 3. Remove from cookbook (repo)
    @cookbook.remove_recipe(index)
    # 4. Display
    display_recipes
  end

  def import
    # ASK VIEW to ask user for a query
    user_query = @view.ask_user_for("What do you want to search for?")

    # ASK SCRAPER for 5 imported recipes
    recipes = AllRecipesScraper.new(user_query).call

    # ASK VIEW to display recipes
    @view.display(recipes)

    # ASK VIEW to ask user for an index
    recipe_index = @view.ask_user_for_index

    recipe = recipes[recipe_index]

    # ask COOKBOOK to persist it
    @cookbook.add_recipe(recipe)
  end

  def mark_as_done
    # ask COOKBOOK for all recipes
    recipes = @cookbook.all
    # ask VIEW to display recipes
    @view.display(recipes)
    # ask VIEW to ask user for an index
    recipe_index = @view.ask_user_for_index
    # ask COOKBOOK for the recipe of that index
    recipe = @cookbook.find(recipe_index)
    # ask MODEL to mark itself as done
    recipe.mark_as_done! # In Memory
    # ask COOKBOOK to persist memory
    @cookbook.persist! # Controller knows about CSV
  end

  private

  def display_recipes
    # 1. Get recipes (repo)
    recipes = @cookbook.all
    # 2. Display recipes in the terminal (view)
    @view.display(recipes)
  end
end
