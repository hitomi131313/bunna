class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path(@post.id)
  end

  def index
    @post = Post.all
  end

  def update
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def destroy
  end


private
  def post_params
    params.require(:post).permit(:image, :title, :body, :genre, :kind, :origin_country, :place)
  end

end
