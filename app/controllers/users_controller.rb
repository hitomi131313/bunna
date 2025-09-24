class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show]
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @keyword = params[:keyword]
		@method = params[:method]
    if params[:keyword].present?
      @users = User.search_for(@keyword, @method).latest
    else
      @users = User.none
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.latest

    if params[:sort] == 'latest'
      @posts = @posts.latest
    else params[:sort] == 'old'
      @posts = @posts.old
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
      @posts = @posts.merge(Post.post_search_for(@post_keyword, @post_method)).latest
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "編集に成功しました"
      redirect_to mypage_path(@user)
    else
      flash.now[:notice] = "編集に失敗しました"
      render :edit
    end
  end

  def mypage
    @user = current_user
    @my_posts = @user.posts.latest
    if params[:sort] == 'latest'
      @my_posts = @my_posts.latest
    else params[:sort] == 'old'
      @my_posts = @my_posts.old
    end

    if params[:selected_genre].present? 
      @my_posts = @my_posts.where(genre:params[:selected_genre])
    end
    if params[:selected_kind].present?
      @my_posts = @my_posts.where(kind:params[:selected_kind])
    end
    if params[:selected_origin_country].present?
      @my_posts = @my_posts.where(origin_country:params[:selected_origin_country])
    end
    if params[:selected_place].present?
      @my_posts = @my_posts.where(place:params[:selected_place])
    end

    @post_keyword = params[:post_keyword]
		@post_method = params[:post_method]
    if params[:post_keyword].present?
      @my_posts = @my_posts.merge(Post.post_search_for(@post_keyword, @post_method)).latest
    end
    #@following_posts = Post.where(user_id: @user.following_ids).all
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to new_user_registration_path
  end


private
  def user_params
    params.require(:user).permit(:profile_image, :name, :last_name, :first_name, :last_name_kana, :first_name_kana, :email, :passward)
  end

  def is_matching_login_user
    user = User.find_by(id: params[:id])
    if !user_signed_in?
      redirect_to new_user_session_path
    elsif user.present? && user.id != current_user.id
        redirect_to posts_path
    else
    end
  end

end
