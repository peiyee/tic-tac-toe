require 'tictactoe'
class GameController < ApplicationController
	def index
		board = Board.new(3)
		gon.game_map = board.game_map
		session[:game_map] =  board.game_map
		# session[:game_map] =  board.game_map
	end

	def update
		# byebug
		# respond_to do |format| 
		#         if true
		#             format.json { render :json => {col: 1, row: 0, sign: "x"}, :status => 200 } 
		#             format.html { render :nothing => true, :notice => 'Update SUCCESSFUL!' } 
		#         else 
		#             format.html { render :action => "index" } 
		#             format.json { render :json => "", :status => :unprocessable_entity } 
		#         end 
		#  end 
		# render nothing: true
		sign = params[:sign]
		col = params[:col]
		row = params[:row]
		engine = Engine.new("x")
		best_move={}
		if params[:game_state] == "new"
			board = Board.new(3)
			best_move = engine.move(board)
			board.mark(best_move)
			session[:game_map] = board.game_map
		else
			game_map = session[:game_map]
			board = Board.new(3)
			board.redraw_map(game_map)
			cell = board.create_cell(row: row.to_i, col: col.to_i, sign: sign)
			board.mark(cell, sign)
			best_move = engine.move(board)
			board.mark(best_move,"x")
			session[:game_map] = board.game_map
		end
		# best_move = engine.move(board)

		render :json => best_move, :status => 200
	end
end
