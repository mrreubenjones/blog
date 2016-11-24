class PostsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_access, only: [:edit, :update, :destroy]
  before_action :initialize_paginated_search, only: [:index, :create]

  def index
    @container = "posts"
    @post = Post.new
    respond_to do |format|
      format.html { render }
      format.text { render }
      format.xml { render xml: @posts }
      format.json { render json: @posts.to_json }

    end
  end

  def new
  end

  def create
    @post = Post.new post_params
    @post.category_id = params["post"]["category"]
    @post.user = current_user
    respond_to do |format|
      if @post.save
        if @post.tweet_this
          client = Twitter::REST::Client.new do |config|
            config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
            config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
            config.access_token        = current_user.oauth_token
            config.access_token_secret = current_user.oauth_secret
          end
          client.update @post.title
        end
        format.js
        redirect_to root_path, notice: 'Post saved'
      else
        flash.now[:alert] = @post.errors.full_messages.join(", ")
        format.html { render root_path }
      end
    end
  end


  def show
    @post = Post.friendly.find params[:id]
    @comment = Comment.new
    @comments = Comment.where(post_id: @post).order(created_at: :desc)
    respond_to do |format|
      format.html {render}
      format.text {render}
      format.json {render json: @post.to_json(include: :comments)}
      format.xml {render xml: @post}
    end
  end

  def edit
    redirect_to root_path, alert: "Access denied" unless can? :edit, @post

    @post = Post.friendly.find params[:id]
  end

  def update
    @post.slug = nil
    redirect_to root_path, alert: "Access denied" unless can? :update, @post

    @post = Post.friendly.find params[:id]
    if @post.update post_params
      redirect_to post_path(@post), notice: "Post Updated"
    else
      render :edit
    end
  end

  def destroy
    redirect_to root_path, alert: "Access denied" unless can? :destroy, @post

    @post = Post.friendly.find params[:id]
      if can? :delete, @post
        @post.destroy
        redirect_to root_path, notice: 'Post deleted'
      else
        redirect_to root_path, alert: 'Post not deleted. Access denied'
      end
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

  def post_params
    params.require(:post).permit([:title,
                                  :body,
                                  :image,
                                  :all_tags,
                                  :tweet_this,
                                  category: []])
  end

end
