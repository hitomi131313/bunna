class PostsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create]
  before_action :is_matching_login_user, only: [:edit, :update]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿に成功しました"
      redirect_to post_path(@post.id)
    else
      flash.now[:notice] = "投稿に失敗しました"
      render :new
    end
  end

  def index
    @post = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "編集に成功しました"
      redirect_to post_path
    else
      flash.now[:notice] = "編集に失敗しました"
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to mypage_path(current_user.id)
  end

  #def timeline
  #end


private
  def post_params
    params.require(:post).permit(:image, :title, :body, :genre, :kind, :origin_country, :place)
  end

  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.user.id == current_user.id
      redirect_to posts_path
    end
  end

end
