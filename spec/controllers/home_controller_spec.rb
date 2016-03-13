require 'rails_helper'
# require 'tictactoe'
RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "render index template" do
    	get :index
    	expect(response).to have_http_status(:success)
      	expect(response).to render_template("index")
    end

    it "create new game_map in session" do
    	board = Tictactoe::Board.new(3)
    	get :index
    	expect(response).to have_http_status(:success)
    	expect(session[:game_map]).to eq(board.game_map)
    end
  end

  describe "POST #update" do
  	let(:valid_params) {{turn: "computer"}}
  	context "no params" do
  		it "should redirect to root" do
  			post :update

  			expect(response).to redirect_to(root_path)
  		end
  	end

  	context "valid params" do
  		it "should return json if new game" do
  			post :update, valid_params
  			expect(response).to have_http_status(:success)
  			expect(response.content_type).to eq("application/json")

  		end
  		it "should include best move if board not over" do
  			post :update, valid_params
  			result = JSON.parse(response.body)
  			expect(response).to have_http_status(:success)
  			expect(result["move"]).not_to be_empty
  			expect(result["over"]).to eq(false)
  		end
  	end
  end
end