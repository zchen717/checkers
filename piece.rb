require_relative 'board'
class Piece

	attr_accessor :pos, :board, :king
	attr_reader :color

	def initialize(pos, board, color, king = false)
		@pos = pos
		@board = board
		@color = color
		@king = king
	end

	def get_direction
		(@color == :red) ? -1 : 1
	end

	def in_bounds?(x, y)
    (0..7).cover?(x) && (0..7).cover?(y)
  end

	def jump_pos(x_pos, y_pos)
		y_direction = (@pos[1] < y_pos) ? 2 : -2
		x_direction = (@pos[0] < x_pos) ? 2 : -2
		x, y = @pos
		new_x = x + x_direction
		new_y = y + y_direction
		if in_bounds?(new_y, new_y)
			return [new_x, new_y] 
		else
			return nil
		end
	end

	def perform_slide(end_pos)
		slideable_moves = move_diffs.select { |move| (move[1] - @pos[1]).abs == 1 }
		valid_move = slideable_moves.include?(end_pos)
		# p "#{move_diffs} inside of perform_slide"
		unless valid_move
			# p "Not a valid slide." 
			return false
		end
		@board[end_pos] = self
		@board[@pos] = nil
		@pos = end_pos
		p move_diffs

		valid_move
	end

	def perform_jump(end_pos)
		# p "#{move_diffs} inside of perform_jump"
		# p "end: #{end_pos}"
		valid_move = move_diffs.include?(end_pos)
		unless valid_move
			# p "Not a valid jump." 
			return false
		end

		remove_x = (end_pos[0] + @pos[0]) / 2
		remove_y = (end_pos[1] + @pos[1]) / 2

		@board[end_pos], @board[@pos] = self, nil
		@board[[remove_x, remove_y]], @pos = nil, end_pos
	  valid_move
	end

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
		moves.select! { |move| in_bounds?(move[0], move[1]) }
		moves.each do |move|
			if !@board[move].nil? 
				jump_check = jump_pos(move[0], move[1])
				break if jump_check.nil?
				if @board[move].color != @color && @board[jump_check].nil?
					valid_moves << jump_check
				end 
				puts
			else
				valid_moves << move
			end
		end
		valid_moves
	end

	def perform_moves(move_sequence)
		if valid_move_sequence?(move_sequence)
			@board.perform_moves! # not sure if this is cool
		else
			raise InvalidMoveError
		end
	end


	def perform_moves!(move_sequence)
		
		if move_sequence.length == 1
			# p " check slide move"
			slid = perform_slide(move_sequence[0])
			unless slid
				# p "check jump move"
				jumped = perform_jump(move_sequence[0])
				raise InvalidMoveError unless jumped
			end
			return
		end

		# p "Checking long sequence"
		valid = nil
		move_sequence.each_with_index do |move, index|
			# p "Checking element #{index + 1} in sequence: #{move}." 
			valid = perform_jump(move)
			# p "Valid: #{valid}"
			@board.display
			break unless valid
		end
		raise InvalidMoveError unless valid

	end


	#where does move_sequence come from?
	def valid_move_sequence?(move_sequence)
		dupped_board = @board.dup_board

		#@board.display
		dupped_board[@pos].perform_moves!(move_sequence)
		begin
			dupped_board[@pos].perform_moves!(move_sequence)
		rescue ArgumentError => error

			puts "#{error.message}"
			return false
		end
		true
	end

	def inspect
		p "Piece"
	end

	def can_promote?
		promote_row = (@color == :red) ? 0 : 7
		@pos[0] == promote_row
	end

end