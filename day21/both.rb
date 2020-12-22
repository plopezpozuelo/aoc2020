require "set"

def all_ingredients(file)
  all_ingredients = []
  file.each do |line|
    ingredients, allergens = line.split("(contains ")
    all_ingredients += ingredients.split(" ")
  end

  all_ingredients
end

def ingredient_allergen_hash(file)
  ingredient_allergen_hash = {}
  file.each do |line|
    ingredients, allergens = line.split("(contains ")
    ingredients = ingredients.split(" ")
    allergens = allergens.split(", ")

    allergens.last.gsub!(")", "")
    allergens.each do |allergen|
      if ingredient_allergen_hash.has_key?(allergen)
        ingredient_allergen_hash[allergen] = ingredient_allergen_hash[allergen].intersection(ingredients)
      else
        ingredient_allergen_hash[allergen] = Set.new(ingredients)
      end
    end
  end

  ingredient_allergen_hash
end

def count_ingredients_without_allergens(all_ingredients, ingredient_allergen_hash)
  allergen_ingredients = ingredient_allergen_hash.values.reduce(&:merge)
  non_allergen_ingredients = Set.new(all_ingredients) - allergen_ingredients

  count = 0
  non_allergen_ingredients.each do |ingredient|
    count += all_ingredients.count(ingredient)
  end

  count
end

def reduce_ingredient_allergen_hash(ingredient_allergen_hash)
  while ingredient_allergen_hash.values.any?{ |value| value.count > 1 }
    ingredient_allergen_hash.each do |key1, value1|
      next if value1.count != 1

      ingredient_allergen_hash.each do |key2, value2|
        next if key1 == key2

        ingredient_allergen_hash[key2] = ingredient_allergen_hash[key2].delete(value1.first)
      end
    end
  end

  ingredient_allergen_hash
end

file = File.readlines("input.txt", chomp: true).map(&:strip)
all_ingredients = all_ingredients(file)
ingredient_allergen_hash = ingredient_allergen_hash(file)
result1 = count_ingredients_without_allergens(all_ingredients, ingredient_allergen_hash)
puts "Puzzle 1 result: #{result1}"

reduced_ingredient_allergen_hash = reduce_ingredient_allergen_hash(ingredient_allergen_hash)
sorted_keys = ingredient_allergen_hash.keys.sort
result2 = sorted_keys.map{ |key| ingredient_allergen_hash[key].to_a }.join(",")
puts "Puzzle 2 result: #{result2}"
