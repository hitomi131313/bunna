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
      case @post.status
      when "published"
        flash[:notice] = "投稿を公開しました"
      when "draft"
        flash[:notice] = "下書きとして保存しました"
      when "unpublished"
        flash[:notice] = "非公開として保存しました"
      end
      redirect_to post_path(@post.id)
    else
      flash.now[:notice] = "投稿に失敗しました"
      render :new
    end
  end

  def index
    if params[:sort] == 'latest'
      @posts = Post.published.latest
    elsif params[:sort] == 'old'
      @posts = Post.published.old
    else
      @posts = Post.published.latest.page(params[:page])
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

    @post_keyword = params[:post_keyword]
		@post_method = params[:post_method]
    if params[:post_keyword].present?
      @posts = Post.post_search_for(@post_keyword, @post_method).latest
    end


    #unless @posts&.any?
      #@posts = Post.published.latest.page(params[:page])
    #end

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
      case @post.status
      when "published"
        flash[:notice] = "投稿を公開しました"
        when "draft"
        flash[:notice] = "下書きとして保存しました"
        when "unpublished"
        flash[:notice] = "非公開として保存しました"
        end
        redirect_to post_path
    else
      flash.now[:notice] = "編集に失敗しました"
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.present?
      flash[:notice] = "投稿を削除しました"
      post.destroy
    else
      flash[:alert] = "投稿が見つかりませんでした"
    end
    redirect_to mypage_path(current_user.id)
  end

  #def timeline
  #end


private
  def post_params
    params.require(:post).permit(:image, :title, :body, :status, :genre, :kind, :origin_country, :place)
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
