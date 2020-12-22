class Helpers
  def self.decks_from_file(filename)
    file = File.readlines(filename, chomp: true).map(&:strip)
    player1_deck = []
    player2_deck = []
    deck = player1_deck

    file.each do |line|
      next if line.include?("Player 1")
      next if line.empty?

      if line.include?("Player 2")
        deck = player2_deck
        next
      end

      deck << line.to_i
    end

    return player1_deck, player2_deck
  end

  def self.calculate_score(deck)
    score = 0
    count = deck.count
    deck.each do |card|
      score += card * count
      count -= 1
    end

    score
  end
end