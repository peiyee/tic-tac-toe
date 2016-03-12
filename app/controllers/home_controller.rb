require 'tictactoe'
class HomeController < ApplicationController
	def index
		board = Board.new(3)
		session[:game_map] =  board.game_map
	end

	def update
		if turn = params[:turn]
			engine = Engine.new("x")
			best_move={}
			game_status = {over: false}
			last_game_map = session[:game_map]
			board = Board.new(3)
			board.redraw_map(last_game_map)
			if turn == "player"
				sign = params[:sign]
				col = params[:col]
				row = params[:row]
				cell = board.create_cell(row: row.to_i, col: col.to_i, sign: sign)
				board.mark(cell, sign)
			end
			if board.over?
				game_status[:over] = true
				game_status[:winner] = board.winner
				session[:game_map] = []
			else
				best_move = engine.move(board)
				board.mark(best_move,"x")
				session[:game_map] = board.game_map
				if board.over?
					game_status[:over] = true
					game_status[:winner] = board.winner
					session[:game_map] = []
				end
			end
		end
		render :json => {move: best_move, game_status: game_status}, :status => 200
	end
end
