class PostsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create ,:show]
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
    if params[:sort] == 'latest'
      @posts = Post.latest
    elsif params[:sort] == 'old'
      @posts = Post.old
    else
      @posts = Post.all.latest
    end

    if params[:selected_genre].present? 
      @posts = @posts.where(genre:params[:selected_genre])
    end
    if params[:selected_kind].present?
      @posts = @posts.where(kind:params[:selected_kind])
    end
    if params[:selected_origin_country].present?
      @posts = @posts.where(origin_country:params[:selected_origin_country])
    end
    if params[:selected_place].present?
      @posts = @posts.where(place:params[:selected_place])
    end
    unless @posts.any?
      @posts = Post.all.latest
    end


    #@genre = params[:selected_genre]

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
    post = Post.find_by(id:params[:id])
    if !user_signed_in?
      redirect_to new_user_session_path
    elsif post.present? && post.user_id != current_user.id
        redirect_to posts_path
    else
    end
  end

end
