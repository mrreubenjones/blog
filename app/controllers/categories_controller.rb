class CategoriesController < ApplicationController
  before_action :authenticate_user
  # before_action :authorize_access

  def new
    @category = Category.new
  end

  def create
    category_params = params.require(:category).permit([:title])
    @category = Category.new category_params
    # @category.user = current_user
      if @category.save
        redirect_to root_path, notice: 'Category saved'
      else
        flash.now[:alert] = @category.errors.full_messages.join(", ")
        render :index
      end
  end

  def destroy
    @category = Category.find params[:id]
    if can? :delete, @category
      @category.destroy
      redirect_to root_path, notice: 'Category deleted'
    else
      redirect_to root_path, alert: 'Category not deleted. Access denied'
    end
  end

private

  def authorize_access
    unless can? :manage, @category
      redirect_to root_path, alert: 'Access denied'
    end
  end



end
