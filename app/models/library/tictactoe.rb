module Tictactoe
	class Board
		attr_reader :size, :winner, :game_map
		Cell = Struct.new(:row, :col, :sign) 
		def initialize(size)
			@size = size
			@game_map = []
			0.upto(size-1) do |r|
				0.upto(size-1) do |c|
					@game_map<<Cell.new(r,c,"")
				end
			end
		end

		def mark(input,sign)
			unless input.kind_of?(Cell)
				input = Cell.new(input[:row], input[:col])
			end
			cell = @game_map.detect {|c| c.row == input.row && c.col == input.col}
			if cell.nil?
				false #return false to show the cell cannot be found
			else
				cell.sign = sign
				true #return true if the cell is marked
			end
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

		def available_moves
			cells = @game_map.select {|cell| cell.sign == ""}
		end

		def has_diagonal_winning_line?
			diag = @game_map.select {|c| c.row==c.col}
			if diag.all? {|c| diag[0].sign == c.sign && !c.sign.empty?}
				@winner = diag[0].sign
				return true
			end
			false
		end

		def has_anti_diagonal_winning_line?
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

		def corner_cell
			[0,size-1].product([0,size-1]).map{|p| Cell.new(p[0],p[1],"x")}.sample
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

	class BoardEngine
		attr_reader :best_choice
		def initialize(sign)
			@player = sign
			@opponent = switch(sign)
		end

		def move(board)
			return if board.over?
			if board.empty?
				# to save calculation time when the board is empty
				@best_choice = board.corner_cell
			else
				minmax(board, @player)
			end
				@best_choice
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
end

