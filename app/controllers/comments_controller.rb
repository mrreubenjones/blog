class CommentsController < ApplicationController
  # skip_before_action :verify_authenticity_token
  before_action :authenticate_user

  def new
    @comment = Comment.new
  end

  def create
    @post             = Post.friendly.find params[:post_id]
    comment_params    = params.require(:comment).permit(:body)
    @comment          = Comment.new comment_params
    @comment.post     = @post
    @comment.user_id  = current_user.id
    if @comment.save
      FeedbackMailer.notify_blog_owner(@comment).deliver_now
      redirect_to post_path(@post), notice: "Comment created"
    else
      render "/posts/show"
    end
  end

  def destroy
    @comment = Comment.find params[:id]
      # if can? :delete, @comment
        post = @comment.post
        @comment.destroy
        redirect_to post_path(post), notice: 'Comment deleted'
      # else
        # redirect_to idea_path(idea), alert: 'Comment not deleted. Access denied'
      # end
    # end
  end


end
