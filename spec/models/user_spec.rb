require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create!(email: 'test@test.com', password: '1234567890') }
  let(:list) { List.create!(title: 'This is a very special test', user: user) }


  context "Every User has" do
    before(:each) do
      @user = User.new
    end

    it "a :lists method" do
      expect(@user).to respond_to :lists
    end

    it "a :likes method" do
      expect(@user).to respond_to :likes
    end

    it "a :tasks method" do
      expect(@user).to respond_to :tasks
    end
  end

  context "Instance method" do
    it "should show the followed lists" do
      Like.create!(user: user, list: list)
      expect(user.followed_lists).to eq [list]
    end
  end
end
