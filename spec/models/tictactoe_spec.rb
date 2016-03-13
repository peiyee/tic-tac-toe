require 'rails_helper'
RSpec.describe Tictactoe do
	let(:size) { 3 }
	let(:board) { Tictactoe::Board.new(size) }
	let(:corner_cell00) { board.create_cell(row: 0, col: 0, sign: x)}
	let(:corner_cell02) { board.create_cell(row: 0, col: 2, sign: x)}
	let(:corner_cell20) { board.create_cell(row: 2, col: 0, sign: x)}
	let(:corner_cell22) { board.create_cell(row: 2, col: 2, sign: x)}
  	let(:x) {"x"}
  	let(:o) {"o"}
  context "Board Class" do
  	describe "#mark" do
  		it "assign signature to cell" do
  			mark = board.mark(corner_cell00,x)
  			expect(mark).to eq true
  		end
  	end
  	describe "#redraw_map" do
  		it "redraw board game map" do
  			new_board = board.dup
  			value = [{"row"=>"0","col"=>"0","sign"=>x},{"row"=>"0","col"=>"1","sign"=>x},{"row"=>"0","col"=>"2","sign"=>x},
  					{"row"=>"1","col"=>"0","sign"=>x},{"row"=>"1","col"=>"1","sign"=>x},{"row"=>"1","col"=>"2","sign"=>x},
  					{"row"=>"2","col"=>"0","sign"=>x},{"row"=>"2","col"=>"1","sign"=>x},{"row"=>"2","col"=>"2","sign"=>x}]
  			new_board.redraw_map(value)
  			expect(new_board.game_map).to_not eq(board.game_map)
  			board.redraw_map(value)
  			expect(board.game_map).to eq(new_board.game_map)
  		end
  		it "raise error when array count less than size**2 " do
  			value = [{"row"=>"0","col"=>"0","sign"=>x},{"row"=>"0","col"=>"1","sign"=>x},{"row"=>"0","col"=>"2","sign"=>x}]
  			expect{board.redraw_map(value)}.to raise_error(RangeError)
  		end
  		it "raise error when array count more than size**2 " do
  			value = [{"row"=>"0","col"=>"0","sign"=>x},{"row"=>"0","col"=>"1","sign"=>x},{"row"=>"0","col"=>"2","sign"=>x},
  					{"row"=>"1","col"=>"0","sign"=>x},{"row"=>"1","col"=>"1","sign"=>x},{"row"=>"1","col"=>"2","sign"=>x},
  					{"row"=>"2","col"=>"0","sign"=>x},{"row"=>"2","col"=>"1","sign"=>x},{"row"=>"2","col"=>"2","sign"=>x},{}]
  			expect{board.redraw_map(value)}.to raise_error(RangeError)
  		end
  	end
  	describe "#available_moves" do
  		it "has size**2 available_moves" do
  			expect(board.available_moves.count).to eq size**2
  		end
  		it "available_moves reduce by 1" do
  			board.mark(corner_cell00,x)
  			expect(board.available_moves.count).to eq (size**2)-1
  		end
  	end

  	describe "#has_diagonal_winning_line?" do

  		it "diagonal winning line = true" do
  			board.mark(board.create_cell(row: 0,col: 0,sign: ""),x)
  			board.mark(board.create_cell(row: 1,col: 1,sign: ""),x)
  			board.mark(board.create_cell(row: 2,col: 2,sign: ""),x)
  			expect(board.has_diagonal_winning_line?).to eq true
  			expect(board.winner).to eq x
  			expect(board.winner?).to eq true
  		end
  	end
  	describe "#has_anti_diagonal_winning_line?" do
  		it "anti diagonal winning line = true" do
	  		board.mark(board.create_cell(row: 0,col: 2,sign: ""),o)
	  		board.mark(board.create_cell(row: 1,col: 1,sign: ""),o)
	  		board.mark(board.create_cell(row: 2,col: 0,sign: ""),o)
	  		expect(board.has_anti_diagonal_winning_line?).to eq true
	  		expect(board.winner).to eq o
	  		expect(board.winner?).to eq true
	  	end
  	end
  	describe "#has_horizontal_winning_line?" do
  		it "horizontal winning line = true" do
  			board.mark(board.create_cell(row: 1,col: 0,sign: ""),o)
  			board.mark(board.create_cell(row: 1,col: 1,sign: ""),o)
  			board.mark(board.create_cell(row: 1,col: 2,sign: ""),o)
  			expect(board.has_horizontal_winning_line?).to eq true
  			expect(board.winner).to eq o
  			expect(board.winner?).to eq true
  		end
  	end
  	describe "#has_vertical_winning_line?" do
  		it "vertical winning line = true" do
  			board.mark(board.create_cell(row: 0,col: 2,sign: ""),x)
  			board.mark(board.create_cell(row: 1,col: 2,sign: ""),x)
  			board.mark(board.create_cell(row: 2,col: 2,sign: ""),x)
  			expect(board.has_vertical_winning_line?).to eq true
  			expect(board.winner).to eq x
  			expect(board.winner?).to eq true
  		end
  	end
  	describe "#empty?" do
  		it "initial state is empty" do
	  		expect(board.empty?).to eq true
	  	end
	  	it "not empty after mark" do
	  		board.mark(board.create_cell(row: 0,col: 2,sign: ""),x)
	  		expect(board.empty?).to eq false
	  	end
  	end
  	describe "#draw?" do
  		it "no winning line" do
  			value = [{"row"=>"0","col"=>"0","sign"=>o},{"row"=>"0","col"=>"1","sign"=>x},{"row"=>"0","col"=>"2","sign"=>x},
  					{"row"=>"1","col"=>"0","sign"=>x},{"row"=>"1","col"=>"1","sign"=>o},{"row"=>"1","col"=>"2","sign"=>o},
  					{"row"=>"2","col"=>"0","sign"=>o},{"row"=>"2","col"=>"1","sign"=>x},{"row"=>"2","col"=>"2","sign"=>x}]
  			board.redraw_map(value)
  			expect(board.draw?).to eq true
  		end
  	end

  	describe "duplicate board" do
  		it "fulling duplicate the board object" do
  			dup_board = board.dup
  			dup_board.mark(corner_cell00,x)
  			expect(dup_board.game_map).to_not eq board.game_map
  			expect(dup_board.size).to eq board.size
  		end
  	end
  end
  context "BoardEngine Class" do
  	let(:engine) {Tictactoe::BoardEngine.new(x)}
  	describe "#move" do
  		it "return corner cell when board is empty" do
			expect(engine.move(board)).to eq(corner_cell00).or eq(corner_cell02).or eq(corner_cell20).or eq(corner_cell22)  			
  		end
  		it "raise argument error" do
  			expect{engine.move}.to raise_error(ArgumentError)
  		end
  		it "return nil when board is over" do
  			value = [{"row"=>"0","col"=>"0","sign"=>o},{"row"=>"0","col"=>"1","sign"=>x},{"row"=>"0","col"=>"2","sign"=>x},
  					{"row"=>"1","col"=>"0","sign"=>x},{"row"=>"1","col"=>"1","sign"=>o},{"row"=>"1","col"=>"2","sign"=>o},
  					{"row"=>"2","col"=>"0","sign"=>o},{"row"=>"2","col"=>"1","sign"=>x},{"row"=>"2","col"=>"2","sign"=>x}]
  			board.redraw_map(value)
  			expect(engine.move(board)).to be_nil
  		end
  		context "find the best move" do
  			describe "choose winning spot" do
  				it "return row: 0, col: 0" do
  				value = [{"row"=>"0","col"=>"0","sign"=>""},{"row"=>"0","col"=>"1","sign"=>o},{"row"=>"0","col"=>"2","sign"=>""},
  						{"row"=>"1","col"=>"0","sign"=>x},{"row"=>"1","col"=>"1","sign"=>x},{"row"=>"1","col"=>"2","sign"=>o},
  						{"row"=>"2","col"=>"0","sign"=>o},{"row"=>"2","col"=>"1","sign"=>""},{"row"=>"2","col"=>"2","sign"=>x}]
  				board.redraw_map(value)
  				choice = engine.move(board)
  				expect(choice.col).to eq 0
  				expect(choice.row).to eq 0
  			end
  			end
  			describe "choose definite winning spot" do
  				it "return row: 1, col: 2" do
  					value = [{"row"=>"0","col"=>"0","sign"=>""},{"row"=>"0","col"=>"1","sign"=>o},{"row"=>"0","col"=>"2","sign"=>x},
  							{"row"=>"1","col"=>"0","sign"=>""},{"row"=>"1","col"=>"1","sign"=>x},{"row"=>"1","col"=>"2","sign"=>""},
  							{"row"=>"2","col"=>"0","sign"=>o},{"row"=>"2","col"=>"1","sign"=>""},{"row"=>"2","col"=>"2","sign"=>""}]
  					board.redraw_map(value)
  					choice = engine.move(board)
  					expect(choice.col).to eq 2
  					expect(choice.row).to eq 1
  				end
  				it "return row: 2, col: 0" do
  					value = [{"row"=>"0","col"=>"0","sign"=>o},{"row"=>"0","col"=>"1","sign"=>""},{"row"=>"0","col"=>"2","sign"=>""},
  							{"row"=>"1","col"=>"0","sign"=>""},{"row"=>"1","col"=>"1","sign"=>x},{"row"=>"1","col"=>"2","sign"=>o},
  							{"row"=>"2","col"=>"0","sign"=>""},{"row"=>"2","col"=>"1","sign"=>""},{"row"=>"2","col"=>"2","sign"=>x}]
  					board.redraw_map(value)
  					choice = engine.move(board)
  					expect(choice.col).to eq 0
  					expect(choice.row).to eq 2
  				end
  			end
  			describe "block player winning spot" do
  				it "return row: 0, col: 2" do
  					value = [{"row"=>"0","col"=>"0","sign"=>o},{"row"=>"0","col"=>"1","sign"=>o},{"row"=>"0","col"=>"2","sign"=>""},
  							{"row"=>"1","col"=>"0","sign"=>""},{"row"=>"1","col"=>"1","sign"=>x},{"row"=>"1","col"=>"2","sign"=>o},
  							{"row"=>"2","col"=>"0","sign"=>""},{"row"=>"2","col"=>"1","sign"=>""},{"row"=>"2","col"=>"2","sign"=>x}]
  					board.redraw_map(value)
  					choice = engine.move(board)
  					expect(choice.col).to eq 2
  					expect(choice.row).to eq 0
  				end
  			end
  		end
  	end
  end
end