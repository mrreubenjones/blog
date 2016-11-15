class PostsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  def index
    @container = "posts"
    @posts = Post.order(created_at: :desc)
    @post = Post.new
    if params[:search]
      @posts = Post.search(params[:search]).order("created_at DESC")
    else
      @posts = Post.all.order('created_at DESC')
    end
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
    @comment = Comment.new
    @comments = Comment.where(post_id: @post).order(created_at: :desc)
  end

  def edit
    redirect_to root_path, alert: "Access denied" unless can? :edit, @post

    @post = Post.find params[:id]

  end

  def update
    redirect_to root_path, alert: "Access denied" unless can? :update, @post

    @post = Post.find params[:id]
    post_params = params.require(:post).permit(:title, :body)
    if @post.update post_params
      redirect_to post_path(@post), notice: "Post Updated"
    else
      render :edit
    end
  end

  def destroy
    redirect_to root_path, alert: "Access denied" unless can? :destroy, @post

    @post = Post.find params[:id]
      # if can? :delete, @comment
        @post.destroy
        redirect_to root_path, notice: 'Comment deleted'
      # else
        # redirect_to idea_path(idea), alert: 'Comment not deleted. Access denied'
      # end
    # end
  end





end
