class Helpers
  def self.groups_from_file(filename)
    file = File.readlines(filename).map(&:strip)
    groups = Array.new()

    file.each_with_index do |line, index|
      if line.empty? || index.zero?
        groups << Array.new()
      end
      next if line.empty?

      groups.last << line
    end

    groups
  end
end