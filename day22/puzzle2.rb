require './helpers'

def play_game(player1_deck, player2_deck)
  player1_deck_cache = {}
  player2_deck_cache = {}
  while player1_deck.count > 0 && player2_deck.count > 0 do
    if player1_deck_cache[player1_deck] && player2_deck_cache[player2_deck]
      return 1
    end

    player1_deck_cache[player1_deck.dup] = true
    player2_deck_cache[player2_deck.dup] = true

    player1_card = player1_deck.shift
    player2_card = player2_deck.shift

    if player1_deck.count >= player1_card && player2_deck.count >= player2_card
      winner = play_game(player1_deck.dup.slice(0, player1_card), player2_deck.dup.slice(0, player2_card))
    else
      winner = player1_card > player2_card ? 1 : 2
    end

    if winner == 1
      player1_deck << player1_card
      player1_deck << player2_card
    else
      player2_deck << player2_card
      player2_deck << player1_card
    end
  end

  player1_deck.empty? ? 2 : 1
end

player1_deck, player2_deck = ::Helpers.decks_from_file("input.txt")
winner = play_game(player1_deck, player2_deck)
winning_deck = winner == 1 ? player1_deck : player2_deck
puts "Result: #{::Helpers.calculate_score(winning_deck)}"
