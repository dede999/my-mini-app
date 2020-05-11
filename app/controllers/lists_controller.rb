class ListsController < ApplicationController
  before_action :set_list, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /lists
  def index
    @lists = List.all.where(is_private: false)
    @lists << current_user.lists unless current_user

    render json: @lists
  end

  # GET /lists/1
  def show
    render json: @list
  end

  # POST /lists
  def create
    @list = List.new(list_params)
    @list.user = current_user

    if @list.save
      render json: @list, status: :created, location: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lists/1
  def update
    if @list.user == current_user
      if @list.update(list_params)
        render json: @list
      else
        render json: @list.errors, status: :unprocessable_entity
      end
    else
      render status: :unauthorized
    end
  end

  # DELETE /lists/1
  def destroy
    if @list.user == current_user
      @list.destroy
      render status: :no_content
    else
      render status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def list_params
      params.require(:list)
          .permit(:title, :is_private, :description,
                  tasks_attributes: [:title, :is_complete])
    end
end
