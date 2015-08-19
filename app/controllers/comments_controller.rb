class CommentsController < ApplicationController
  before_action :require_user
  
  def create
    @post = Post.find_by slug: params[:post_id]
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash['notice'] = "Your comment was successfully created."
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end
  
  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: @comment, user: current_user, vote: params[:vote])
    respond_to do |format|
      format.html do
        if @vote.errors.any?
          flash['error'] = "You can only vote once."
        else
          flash['notice'] = "Your vote was counted."
        end
        redirect_to :back
      end
      format.js
    end
  end
  
  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end