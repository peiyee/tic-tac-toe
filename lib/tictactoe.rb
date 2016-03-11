class Board
	attr_accessor :game_state, :game_map
	Cell = Struct.new(:row, :col, :sign) 
	def initialize(size)
		@game_map = []
		# cell00 = Cell.new(0,0,"")
	    # cell01 = Cell.new(0,1,"")
		# cell02 = Cell.new(0,2,"")
		# cell10 = Cell.new(1,0,"")
		# cell11 = Cell.new(1,1,"")
		# cell12 = Cell.new(1,2,"")
		# cell20 = Cell.new(2,0,"")
		# cell21 = Cell.new(2,1,"")
		# cell22 = Cell.new(2,2,"")
		# @game_map = [Cell.new(0,0,"o"),Cell.new(0,1,""),Cell.new(0,2,""),
		# 			 Cell.new(1,0,""),Cell.new(1,1,"x"),Cell.new(1,2,""),
		# 			 Cell.new(2,0,""),Cell.new(2,1,""),Cell.new(2,2,"o")]
		0.upto(size-1) do |r|
			0.upto(size-1) do |c|
				@game_map<<Cell.new(r,c,"")
			end
		end
		@size = size
	end

	def size 
		@size
	end
	def mark(previous_cell,sign)
		cell = @game_map.detect {|c| c.row == previous_cell.row && c.col == previous_cell.col}
		cell.sign = sign
	end

	def redraw_map(value)
		@game_map = []
		value.each do |v|
			temp = v.symbolize_keys
			@game_map<<Cell.new(temp[:row].to_i,temp[:col].to_i,temp[:sign])
		end
	end
	def create_cell(col:,row:,sign:)
		Cell.new(row,col,sign)
	end
	def show
		map = @game_map.each_slice(3).to_a
		map.each do |row|
			print "|"
			row.each do |col|
				print (col.sign.empty? ? "_" : col.sign) + "|"
			end
			puts ""
		end
	end

	def available_moves
		cells = @game_map.select {|cell| cell.sign == ""}
	end

	def total_winning_spots(sign)
		total = horizontal_winning_spot(sign) + vertical_winning_spot(sign)+anti_diagonal_winning_spot(sign)+diagonal_winning_spot(sign)
		total.compact
	end

	def detect_winning_spot(ary,sign)
		if ary.all? {|cell| cell.sign==sign || cell.sign==""}
			if ary.select {|cell| cell.sign==sign}.size == size-1
				return ary.select {|cell| cell.sign==""}.first
			end
		end
	end

	def horizontal_winning_spot(sign)
		winning_spots = []
		@game_map.each_with_index do |row,ri|
			next unless row.include? sign
			temp = row.map.with_index do |col,ci|
				Cell.new(ri,ci,col)
			end
			winning_spots<<detect_winning_spot(temp,sign) if detect_winning_spot(temp,sign)
		end
		winning_spots
	end

	def vertical_winning_spot(sign)
		winning_spots = []
		0.upto(size-1) do |i|
			temp = []
			@game_map.each_with_index do |row,ri|
				# p Cell.new(ri,ci,@game_map[i][ci])
				temp<<Cell.new(ri,i,row[i])
			end
			winning_spots<<detect_winning_spot(temp,sign) if detect_winning_spot(temp,sign)
		end
		winning_spots
	end

	def diagonal_winning_spot(sign)
		temp_diag = []

		@game_map.each_with_index do |row,ri|
			row.each_with_index do |col,ci|
				if ci==ri
					temp_diag<<Cell.new(ri,ci,col)
				end
			end
		end
		return [detect_winning_spot(temp_diag,sign)]
	end

	def anti_diagonal_winning_spot(sign)
		temp_diag = []
		@game_map.each_with_index do |row,ri|
			temp_diag<<Cell.new(ri,(size-1)-ri,row[(size-1)-ri])
		end
		return [detect_winning_spot(temp_diag,sign)]
	end

	def has_diagonal_winning_line?
		temp_diag = []
		diag = @game_map.select {|c| c.row==c.col}
		if diag.all? {|c| diag[0].sign == c.sign && !c.sign.empty?}
			@winner = diag[0].sign
			return true
		end
		false
	end



	def has_anti_diagonal_winning_line?
		temp_diag = []
		anti_diag = []
		0.upto(size-1) do |i|
			anti_diag<<@game_map.find {|c| c.row == i && c.col == (size-1-i)}
		end
		if anti_diag.all? {|c| anti_diag[0].sign == c.sign && !c.sign.empty?}
			@winner = anti_diag[0].sign
			return true
		end
		false
	end

	def has_horizontal_winning_line?
		0.upto(size-1) do |i|
			row = @game_map.select {|c| c.row==i}
			if row.all? {|r| row[0].sign==r.sign && !r.sign.empty?}
				@winner = row[0].sign
				return true
			end
		end
		false
	end

	def has_vertical_winning_line?
		0.upto(size-1) do |i|
			column = @game_map.select {|c| c.col==i}
			if column.all? {|col| column[0].sign==col.sign && !col.sign.empty?}
				@winner = column[0].sign
				return true
			end
		end
		false
	end

	def empty?
		available_moves.count == size**2
	end

	def winner?
		has_vertical_winning_line? || has_horizontal_winning_line? || has_diagonal_winning_line? || has_anti_diagonal_winning_line?
	end

	def winner
		@winner
	end

	def corner_cell
		[0,size-1].product([0,size-1]).map{|p| Cell.new(p[0],p[1],"")}.sample
	end

	def draw
		available_moves.empty? && !winner?
	end

	def over?
		winner? || draw
	end

	def initialize_dup(other)
      super(other)
      @game_map = Marshal.load(Marshal.dump(other.game_map))
    end
end

class Engine
	 attr_reader :best_choice
	 def initialize(sign)
        @player = sign
        @opponent = switch(sign)
      end

      def move(board)
      	if board.empty?
      		@best_choice = board.corner_cell
  		else
  			minmax(board, @player)
  		end
  		@best_choice
        # board.mark(best_choice, @player)
      end
	 def minmax(board, current_player)
         if board.over?
         	return score(board)
         end
        scores = {}
        board.available_moves.each do |cell|
          new_board = board.dup
          new_board.mark(cell, current_player)
          scores[cell] = minmax(new_board, switch(current_player))
        end

        @best_choice, best_score = best_move(current_player, scores)
        best_score
      end

      def game_over?(board)
        board.winner || board.tie?
      end

      def best_move(sign, scores)
        if sign == @player
          scores.max_by { |_k, v| v }
        else
          scores.min_by { |_k, v| v }
        end
      end

      def score(board)
        if board.winner == @player
          return 10
        elsif board.winner == @opponent
          return -10
        end
        0
      end

      def switch(sign)
        sign == 'x' ? 'o' : 'x'
      end
end