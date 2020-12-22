require './helpers'

def play_round(player1_deck, player2_deck)
  player1_card = player1_deck.shift
  player2_card = player2_deck.shift

  if player1_card > player2_card
    player1_deck << player1_card
    player1_deck << player2_card
  else
    player2_deck << player2_card
    player2_deck << player1_card
  end
end

player1_deck, player2_deck = ::Helpers.decks_from_file("input.txt")
while player1_deck.count > 0 && player2_deck.count > 0 do
  play_round(player1_deck, player2_deck)
end
winning_deck = player1_deck.empty? ? player2_deck : player1_deck
puts "Result: #{::Helpers.calculate_score(winning_deck)}"
