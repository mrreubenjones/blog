class PostsController < ApplicationController

  def index
    @container = "posts"
    @posts = Post.order(created_at: :desc)
    # @body = self.snippet(50)
    @post = Post.new

  end

  def new
  end

  def create
    post_params = params.require(:post).permit([:title, :body])
    @post = Post.new post_params
    if @post.save
      redirect_to post_path(@post)
    else
      flash.now[:alert] = @post.errors.full_messages.join(", ")
      # Tried to render below, but then I get an error with the posts list
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
