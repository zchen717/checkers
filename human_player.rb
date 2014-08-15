class HumanPlayer
  
  def initialize(board, color) 
    @board = board
    @color = color
  end
  
  def play_turn
    begin
    	input = get_user_input
	  rescue ArgumentError => e
	   	retry
	  end
    begin
	    start_coord = input[0]
	    move_sequence = input[1]
    	@board[start_coord].perform_moves(move_sequence) 
    rescue ArgumentError => error
    	puts "That was an invalid sequence."
    	retry
    end
  end

  def get_user_input
    puts "Please enter in the coordinates of the piece you want to move(e.g. A0
    	to select the piece in the top left hand corner): "
    start_coord = coord_translate(gets.chomp)
    puts "Please enter in the coordinates you want to move to or the sequence 
    of moves you would like to make(e.g. A0 B1 C2): "
    move_sequence = get_sequence(gets.chomp)
    raise "There's no piece in that spot." if @board[start_coord].nil?
    raise "That's not your piece." if @board[start_coord].color != @color
    [start_coord, move_sequence]
  end
  
  def coord_translate(coord)
    y_coord, x_coord = coord.split("")
    y_coord.upcase!
    letter_array = ('A'..'H').to_a
    actual_y_index = letter_array.index(y_coord)
    actual_x_index = x_coord.to_i
    [actual_x_index, actual_y_index]
  end

  def get_sequence(string)
  	actual_seq = []
  	seq_split = string.split(" ")
  	seq_split.each do |coord|
  		actual_seq << coord_translate(coord)
  	end
  	actual_seq
  end
  
end