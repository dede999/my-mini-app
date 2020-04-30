require 'rails_helper'

RSpec.describe List, type: :model do
  let(:user) { User.create!(email: 'test@test.com', password: '1234567890') }
  let(:params) {
    {
        title: 'It is nothing but a test',
        user: user,
        tasks_attributes: [
            { title: 'One Big Task LOL', is_complete: true },
            { title: 'Another Big Task LOL', is_complete: false }
        ]
    }
  }

  context "When Validating" do
    before(:each) do
      List.all.destroy_all
    end

    it "Valid params generate a new instance" do
      expect(List.new(params)).to be_valid
    end

    it "Tasks can be created from this instance" do
      expect {
        List.create!(params)
      }.to change(Task, :count).by(2)
    end

    it "A new instance won't be created without a user" do
      params.delete :user
      expect(
          List.create(params).errors.messages
      ).to have_key :user
    end

    it "A new instance won't be created without a title" do
      params.delete :title
      expect(
          List.create(params).errors.messages
      ).to have_key :title
    end

    it "A new instance won't be created with a small title" do
      params[:title] = "Invalid"
      expect(
          List.create(params).errors.messages
      ).to have_key :title
    end

    it "A user won't create a new instance with the same title" do
      List.create!(params)
      expect(List.new(params)).not_to be_valid
    end
  end

  context "Any instance has" do
    before(:each) do
      @list = List.new
    end

    it "a :user method" do
      expect(@list).to respond_to :user
    end

    it "a :likes method" do
      expect(@list).to respond_to :likes
    end

    it "a :tasks method" do
      expect(@list).to respond_to :tasks
    end
  end

  context "Instance methods" do
    it "returns the 2 1st level children" do
      List.all.destroy_all
      list = List.create!(params)
      expect(list.first_level_children.length).to eq 2
    end
  end
end
