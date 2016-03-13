class HomeController < ApplicationController
	before_action :require_params, only: :update
	include Tictactoe
	def index
		board = Board.new(3)
		session[:game_map] =  board.game_map
	end

	def update
		engine = BoardEngine.new("x")
		last_game_map = session[:game_map]
		board = Board.new(3)
		board.redraw_map(last_game_map)
		board.mark({row: params[:row].to_i, col: params[:col].to_i}, params[:sign]) if params[:turn] == "player"
		best_move = engine.move(board)
		if board.over?
			clear_session
			render :json => {move: best_move, over: true, winner: board.winner}, :status => 200
		elsif best_move && board.mark(best_move,"x") && board.over?
			clear_session
			render :json => {move: best_move, over: true, winner: board.winner}, :status => 200
		else
			session[:game_map] = board.game_map
			render :json => {move: best_move, over: false}, :status => 200
		end
	end

	private

	def clear_session
		session[:game_map] = []
	end

	def require_params
		if params[:turn].nil?
			flash[:error] = "Missing required parameters"
			redirect_to root_path
		end
	end
end
