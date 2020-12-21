require "set"

file = File.readlines("input.txt", chomp: true).map(&:strip)

all_ingredients = []
ingredient_allergen_hash = {}
file.each do |line|
  ingredients, allergens = line.split("(contains ")
  ingredients = ingredients.split(" ")
  all_ingredients += ingredients
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

allergen_ingredients = ingredient_allergen_hash.values.reduce(&:merge)
non_allergen_ingredients = Set.new(all_ingredients) - allergen_ingredients

result1 = 0
non_allergen_ingredients.each do |ingredient|
  result1 += all_ingredients.count(ingredient)
end

puts "Puzzle 1 result: #{result1}"

while ingredient_allergen_hash.values.any?{ |value| value.count > 1 }
  ingredient_allergen_hash.each do |key1, value1|
    next if value1.count != 1

    ingredient_allergen_hash.each do |key2, value2|
      next if key1 == key2

      ingredient_allergen_hash[key2] = ingredient_allergen_hash[key2].delete(value1.first)
    end
  end
end

sorted_keys = ingredient_allergen_hash.keys.sort
result2 = sorted_keys.map{ |key| ingredient_allergen_hash[key].to_a }.join(",")

puts "Puzzle 2 result: #{result2}"
