require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { User.create!(email: 'test@test.com', password: '1234567890') }
  let(:list) { List.create!(title: 'This is a very special test', user: user) }

  let(:params) {
    {
        title: 'Some other very special task',
        list: list,
        child_tasks_attributes: [
            {
                title: 'Another super test',
                list: list,
                child_tasks_attributes: [
                    {
                        title: 'Imagination running up',
                        list: list
                    }
                ]
            },
            {
                title: 'You cannot take this one super test',
                list: list, is_complete: true
            }
        ]
    }
  }
  let(:task) { Task.create!(params) }

  context "When Validating" do
    before(:each) do
      Task.all.destroy_all
    end

    it "creates instances with perfect set of parameters" do
      expect(Task.new(params)).to be_valid
    end

    it "should not allow a task without a list" do
      params.delete :list
      expect(
          (Task.create(params)).errors.messages
      ).to have_key :list
    end

    it "should not allow a task without a title" do
      params.delete :title
      expect(
          (Task.create(params)).errors.messages
      ).to have_key :title
    end

    it "should not allow a task with a small title" do
      params[:title] = 'Tiny one'
      expect(
          (Task.create(params)).errors.messages
      ).to have_key :title
    end

    it "should not allow tasks with the same title within a list" do
      Task.create!(params)
      params[:title] = 'Another super test'
      expect(
          (Task.create(
              { title: 'Another super test', list: list}
          )).errors.messages
      ).to have_key :title
    end
  end

  context "Every instance has" do
    before(:all) do
      @task = Task.new
    end

    it "a :list method" do
      expect(@task).to respond_to :list
    end

    it "a :parent method" do
      expect(@task).to respond_to :parent
    end

    it "a :child_tasks method" do
      expect(@task).to respond_to :child_tasks
    end
  end

  context "Instance methods" do

    it "should close child tasks if parent is closed" do
      first_child = task.child_tasks.first
      first_child.update({ is_complete: true })

      expect(first_child.child_tasks.first.is_complete).to be_truthy
    end

    it "check if parent tasks should be closed" do
      second_child = task.child_tasks.last
      second_child.update({ is_complete: false })

      expect(task.is_complete).to be_falsey
    end
  end
end
