class Piece

	attr_accessor :pos, :board, :king
	attr_reader :color

	def initialize(pos, board, color)
		@pos = pos
		@board = board
		@color = color
		@king = false
	end

	#returns the direction the piece should be moving depending on the color of the piece.
	def get_direction
		(@color == :red) ? -1 : 1
	end


	#y_coord is used to track where the piece you are attempting to jump is located 
	#relative to the current piece. Returns the location you are attempting to jump to.
	def jump_pos(x_pos, y_pos)
		y_direction = (@pos[1] < y_pos) ? 2 : -2
		x_direction = (@pos[0] < x_pos) ? 2 : -2
		x, y = @pos
		[(x + x_direction), (y + y_direction)]
	end


	#if there are no pieces at the locations listed by move_diffs then slide current piece to one of the available locations
	def perform_slide(end_pos)
		valid_move = move_diffs.include?(end_pos)
		unless valid_move
			p "Not a valid slide." 
			return 
		end
		@board[end_pos] = self
		@board[@pos] = nil
		@pos = end_pos
		p move_diffs

		valid_move
	end


	#if there is a piece at one of the two locations then check the location behind it to see if it is jumpable
	def perform_jump(end_pos)
		valid_move = move_diffs.include?(end_pos)
		unless valid_move
			p "Not a valid jump." 
			return 
		end

		remove_x = (end_pos[0] + @pos[0]) / 2
		remove_y = (end_pos[1] + @pos[1]) / 2

		@board[end_pos], @board[@pos] = self, nil
		@board[[remove_x, remove_y]], @pos = nil, end_pos
	  valid_move
	end

	#returns array containing the two spots in front of piece diagonally unless they 
	#are occupied. If they are occupied then you delete the diagonal move and add the 
	#jumped to spot if it is empty.
	def move_diffs
		moves = []
		valid_moves = []
		x, y = @pos
		new_x = x + get_direction
		moves << [new_x, y - 1]
		moves << [new_x, y + 1]
		if @king
			king_x = x - get_direction
			moves << [king_x, y - 1]
			moves << [king_x, y + 1]
		end
		moves.each do |move|
			#checks to see if there is a piece in the spot.
			if !@board[move].nil? 
				#checks to see if that piece is the same color.
				if @board[move].color != @color && @board[jump_pos(move[0], move[1])].nil?
					#delete the move from list if the location you jump to is occupied.
					#or if the piece at the location is the same color.
					valid_moves << jump_pos(move[0], move[1])
				end 
				puts
			else
				valid_moves << move
			end
		end
		valid_moves
	end

	def perform_moves!(move_sequence)
		if move_sequence.length == 1
			moved = perform_slide(move_sequence.first)
			perform_jump(move_sequence.first) unless moved
		end

	end

	def valid_move_sequence?
		dupped_board = dup_board

	end

	def inspect
		p "Piece"
	end

	#Returns true if the x position of a piece is at the correct end row.
	def can_promote?
		promote_row = (@color == :red) ? 0 : 7
		@pos[0] == promote_row
	end

end