require_relative 'board'
require_relative 'piece'
require_relative 'human_player'

class Game

	def initialize
    @board = Board.new(true)
    @players = {
    	:red => HumanPlayer.new(@board, :red), 
    	:black => HumanPlayer.new(@board, :black)
    }
    @current_player = :red
    play_game
  end

  def play_game
  	@board.display
  	until game_over?
  		@players[@current_player].play_turn
  		@board.display
  		@current_player = (@current_player == :red) ? :black : :red
  	end
  	puts "Gameover!"
  end

  def game_over?
  	p @board.color(@current_player).count
  	@board.color(@current_player).empty?
  end
end

if __FILE__ == $PROGRAM_NAME
	g = Game.new
end