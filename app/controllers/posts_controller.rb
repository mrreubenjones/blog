class PostsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_access, only: [:edit, :update, :destroy]
  before_action :initialize_paginated_search, only: [:index, :create]

  def index
    @container = "posts"
    @post = Post.new
  end

  def new
  end

  def create
    post_params = params.require(:post).permit([:title, :body])

    @post = Post.new post_params
    @post.user = current_user
    if @post.save
      redirect_to root_path
    else
      flash.now[:alert] = @post.errors.full_messages.join(", ")
      render :index
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

private

  def initialize_paginated_search
    if params[:search]
      @posts = Post.search(params[:search]).page(params[:page]).per(10).order("created_at DESC")
    else
      @posts = Post.all.page(params[:page]).per(10).order('created_at DESC')
    end
  end

  def authorize_access
    unless can? :manage, @post
      redirect_to root_path, alert: 'Access denied'
    end
  end

end
