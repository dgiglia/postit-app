class CommentsController < ApplicationController
  before_action :require_user
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash['notice'] = "Your comment was successfully created."
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end
  
  def comment_params
    params.require(:comment).permit(:body)
  end
end