class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update]
  
  def index
    @posts = (Post.all.limit(Post::PER_PAGE).offset(params[:offset])).sort_by{|x| x.total_votes}.reverse
    @pages = (Post.all.size / Post::PER_PAGE) 
    @pages += 1 if (Post.all.size % Post::PER_PAGE) > 0
  end
  
  def show
    @comment = Comment.new
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash['notice'] = "Your post was successfully created."
      redirect_to posts_path
    else
      render :new
    end
  end
  
  def edit 
  end
  
  def update    
    if @post.update(post_params)
      flash['notice'] = "Your post was successfully updated."
      redirect_to root_path
    else
      render :edit
    end
  end
  
  def vote
    @vote = Vote.create(voteable: @post, user: current_user, vote: params[:vote])    
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
  def post_params
    params.require(:post).permit!
  end
  
  def set_post
    @post = Post.find_by slug: params[:id]
  end
  
  def require_same_user
    access_denied unless logged_in? and (current_user == @post.user || current_user.admin?)
  end
end
