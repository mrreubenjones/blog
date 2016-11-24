class FeedbackMailer < ApplicationMailer

  def notify_blog_owner(comment)
    @comment = comment
    @post = @comment.post
    @user = @post.user
    if @user && @user.email
      mail(to: @user.email, subject: 'Someone commented on your post')
    end
  end

end
