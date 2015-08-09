class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]
  
  def index
    @posts = Post.all
  end
  
  def show
    @comment = Comment.new
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user = User.first #until we have authentication set up
    if @post.save
      flash[:notice] = "Your post was successfully created."
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
      redirect_to posts_path
    else
      render :edit
    end
  end
  
  def post_params
    params.require(:post).permit!
  end
  
  def set_post
    @post = Post.find(params[:id])
  end
end
