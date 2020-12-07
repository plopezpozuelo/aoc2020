def file_to_outer_bag_hash(filename)
  file = File.readlines(filename, chomp: true)
  outer_bag_hash = Hash.new()

  file.each do |line|
    outer_bag, inner_bags = line.split('bags contain').map(&:strip)
    inner_bags = inner_bags.split(',').map(&:split)
    inner_bags = inner_bags.map{|value| [value[0], value[1] + ' ' + value[2]]}

    if outer_bag_hash.has_key?(outer_bag)
      inner_bags.each do |value|
        outer_bag_hash[outer_bag] << value
      end
    else
      outer_bag_hash[outer_bag] = inner_bags
    end
  end

  outer_bag_hash
end

def find_bags_contained(colour, outer_bag_hash)
  total_bags = 1
  outer_bag_hash[colour].each do |inner_bag|
    next if outer_bag_hash[colour] == [["no", "other bags."]]

    total_bags += inner_bag.first.to_i * find_bags_contained(inner_bag.last, outer_bag_hash)
  end

  total_bags
end

outer_bag_hash = file_to_outer_bag_hash("input.txt")
total_bags_contained = find_bags_contained('shiny gold', outer_bag_hash) - 1
puts "A shiny gold bag contains #{total_bags_contained} other bags"
