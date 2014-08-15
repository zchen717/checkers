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

  def color(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end

  def display
    print "   "
    ('A'..'H').each do |num|
      print " #{num}  "
    end
    puts
    @board.each_with_index do |row, index|
      print "#{index} "
      row.each do |piece|
        if piece.nil? 
          print "|  |"
        else
        	if !piece.king
          	print "|#{piece.color.to_s[0]}#{piece.class.to_s[0]}|" 
          else
          	print "|#{piece.color.to_s[0]}K|"
          end
        end
      end
      puts
    end
    puts
    puts
    puts
  end

  def dup_board
    dupped_board = Board.new(false)
    (color(:red) + color(:black)).each do |piece|
      dupped_board[piece.pos] = piece.class.new(piece.pos, dupped_board, piece.color, piece.king)
    end
    dupped_board
  end

end