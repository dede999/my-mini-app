require 'rails_helper'

RSpec.describe "UserActions", type: :request do

  describe "GET /follow_a_list" do
    it "returns http success" do
      get "/user_actions/follow_a_list"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show_followed_lists" do
    it "returns http success" do
      get "/user_actions/show_followed_lists"
      expect(response).to have_http_status(:success)
    end
  end

end
