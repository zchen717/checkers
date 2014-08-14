class Game

def initialize
    @board = Board.new(true)
    @player1 = HumanPlayer.new(names[0], @board, :white)
    @player2 = HumanPlayer.new(names[1], @board, :black)
    play_game
  end
end