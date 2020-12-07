def file_to_inner_bag_hash(filename)
  file = File.readlines("input.txt", chomp: true)
  inner_bag_hash = Hash.new()
  file.each do |line|
    outer_bag, inner_bags = line.split('bags contain').map(&:strip)
    inner_bags = inner_bags.split(',').map(&:split)
    inner_bags = inner_bags.map{|value| value[1] + ' ' + value[2]}

    inner_bags.each do |inner_bag|
      if inner_bag_hash.has_key?(inner_bag)
        inner_bag_hash[inner_bag] << outer_bag
      else
        inner_bag_hash[inner_bag] = [outer_bag]
      end
    end
  end

  inner_bag_hash
end

def find_bags_containing(colour, inner_bag_hash, output_bags)
  if inner_bag_hash.has_key?(colour)
    output_bags << inner_bag_hash[colour]
    output_bags.flatten!
    inner_bag_hash[colour].each do |outer_bag_colour|
      find_bags_containing(outer_bag_colour, inner_bag_hash, output_bags)
    end
  end
end

inner_bag_hash = file_to_inner_bag_hash("input.txt")
output_bags = Array.new()
find_bags_containing('shiny gold', inner_bag_hash, output_bags)
puts "Bags of #{output_bags.uniq.count} different colours can contain a shiny gold bag"
