require_relative 'piece'
class Board

	attr_accessor :board

	def initialize(start_condition)
    	@board = Array.new(8) { [nil] * 8 }
    	start_config if start_condition
  end

  def start_config
  	fill_three_rows(:black)
  	fill_three_rows(:red)
  end

  def fill_three_rows(color)
  	start_row = (color == :black) ? 0 : 5
  	one_off = color == :black

  	odd_col = [1, 3, 5, 7]
  	even_col = [0, 2, 4, 6]

  	(start_row...(start_row + 3)).each do |row|
	  	if one_off
	  		odd_col.each do |col|
	  			self[[row, col]] = Piece.new([row, col], self, color)
	  		end
	  	else
	  		even_col.each do |col|
	  			self[[row, col]] = Piece.new([row, col], self, color)
	  		end
	  	end
	  	one_off = !one_off
  	end

  end

	def [](pos)
    x, y = pos
    @board[x][y]
	end

  def []=(pos, value)
    x, y = pos
    @board[x][y] = value
  end

    def display
	    print "   "
	    ('A'..'H').each do |num|
	      print " #{num}  "
	    end
	    puts
	    @board.each_with_index do |row, index|
	      print "#{8 - index} "
	      row.each do |piece|
	        if piece.nil? 
	          print "|  |"
	        else
	          print "|#{piece.color.to_s[0]}#{piece.class.to_s[0]}|" 
	        end
	      end
	      puts
	    end
	    puts
	    puts
	    puts
  end

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new(true)
  b.display
  p "#{b[[5, 2]].move_diffs}: possible moves for [5, 2]."
  b[[5, 2]].perform_slide([4, 3])
  b.display
  p "#{b[[2, 3]].move_diffs}: possible moves for [2, 3]."
  b[[2, 3]].perform_slide([3, 4])
  b.display
  p "#{b[[5, 6]].move_diffs}: possible moves for [5, 6]."
  b[[5, 6]].perform_slide([4, 7])
  b.display
  p "#{b[[3, 4]].move_diffs}: possible moves for [3, 4]."
  b[[3, 4]].perform_jump([5, 2])
  b.display
end