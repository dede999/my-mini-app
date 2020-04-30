require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { User.create!(email: 'test@test.com', password: '1234567890') }
  let(:list) { List.create!(title: 'This is a very special test', user: user) }
  let(:params) {
    { user: user, list: list }
  }

  context 'When validating' do
    it 'should allow user to follow a list if it\'s not followed yet' do
      Like.all.destroy_all
      expect(Like.new(params)).to be_valid
    end

    it "should not allow a user to follow an already followed list" do
      Like.all.destroy_all
      Like.create!(params)
      expect(Like.new(params)).not_to be_valid
    end

    it "should not allow a like without a list" do
      params.delete :list
      expect(
          (Like.create(params)).errors.messages
      ).to have_key :list
    end

    it "should not allow a like without a user" do
      params.delete :user
      expect(
          (Like.create(params)).errors.messages
      ).to have_key :user
    end
  end
end
