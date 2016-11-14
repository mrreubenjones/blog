class PostsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]


  def index
    @container = "posts"
    @posts = Post.order(created_at: :desc)
    @post = Post.new
  end

  def new
  end

  def create
    post_params = params.require(:post).permit([:title, :body])
    @post = Post.new post_params
    if @post.save
      redirect_to root_path
    else
      flash.now[:alert] = @post.errors.full_messages.join(", ")
      redirect_to root_path
    end
  end


  def show
    @post = Post.find params[:id]
  end

  def edit
  end

  def update
  end

  def destroy
  end





end
