class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show]
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @user_keyword = params[:user_keyword]
		@user_method = params[:user_method]
    if params[:user_keyword].present?
      @users = User.user_search_for(@user_keyword, @user_method).latest.page(params[:page])
    else
      @users = User.none
    end
  end


  def show
    @user = User.find(params[:id])
    @posts = @user.posts.published.latest.page(params[:page])

    if params[:sort] == 'latest'
      @posts = @posts.published.latest
    elsif params[:sort] == 'old'
      @posts = @posts.published.old
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
    @my_posts = @user.posts.latest.page(params[:page])
    if params[:sort] == 'latest'
      @my_posts = @my_posts.latest
    elsif params[:sort] == 'old'
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

    @published_posts = @my_posts.published
    @draft_posts = @my_posts.draft
    @unpublished_posts = @my_posts.unpublished
    #@following_posts = Post.where(user_id: @user.following_ids).all
  end


  def following_posts
    following_ids = current_user.followings.pluck(:id)
    @following_posts = Post.where(user_id: following_ids).published.latest.page(params[:page])

    if params[:sort] == 'latest'
      @following_posts = @following_posts.published.latest
    elsif params[:sort] == 'old'
      @following_posts = @following_posts.published.old
    end

    if params[:selected_genre].present? 
      @following_posts = @following_posts.where(genre:params[:selected_genre])
    end
    if params[:selected_kind].present?
      @following_posts = @following_posts.where(kind:params[:selected_kind])
    end
    if params[:selected_origin_country].present?
      @following_posts = @following_posts.where(origin_country:params[:selected_origin_country])
    end
    if params[:selected_place].present?
      @following_posts = @following_posts.where(place:params[:selected_place])
    end

    @post_keyword = params[:post_keyword]
		@post_method = params[:post_method]
    if params[:post_keyword].present?
      @following_posts = @following_posts.merge(Post.post_search_for(@post_keyword, @post_method)).latest
    end
  end


  def favorites
    @favorite_posts = favorite_posts.merge(Favorite.recent).page(params[:page])

    if params[:sort] == 'latest'
      @favorite_posts = @favorite_posts.latest
    elsif params[:sort] == 'old'
      @favorite_posts = @favorite_posts.old
    end

    if params[:selected_genre].present? 
      @favorite_posts = @favorite_posts.where(genre:params[:selected_genre])
    end
    if params[:selected_kind].present?
      @favorite_posts = @favorite_posts.where(kind:params[:selected_kind])
    end
    if params[:selected_origin_country].present?
      @favorite_posts = @favorite_posts.where(origin_country:params[:selected_origin_country])
    end
    if params[:selected_place].present?
      @favorite_posts = @favorite_posts.where(place:params[:selected_place])
    end

    @post_keyword = params[:post_keyword]
		@post_method = params[:post_method]
    if params[:post_keyword].present?
      @favorite_posts = @favorite_posts.merge(Post.post_search_for(@post_keyword, @post_method)).latest
    end
  end


  def destroy
    user = User.find(params[:id])
    if user.present?
      flash[:notice] = "ユーザを削除しました"
      user.destroy
    else
      flash[:alert] = "ユーザが見つかりませんでした"
    end
      redirect_to new_user_registration_path
  end


  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.page(params[:page])
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.page(params[:page])
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

  def favorite_posts
    current_user.favorite_posts.includes(:user)
  end

  # def search_post(posts)
  #   if params[:sort] == 'latest'
  #     posts = posts.latest
  #   else params[:sort] == 'old'
  #     posts = posts.old
  #   end

  #   if params[:selected_genre].present? 
  #     posts = posts.where(genre:params[:selected_genre])
  #   end
  #   if params[:selected_kind].present?
  #     posts = posts.where(kind:params[:selected_kind])
  #   end
  #   if params[:selected_origin_country].present?
  #     posts = posts.where(origin_country:params[:selected_origin_country])
  #   end
  #   if params[:selected_place].present?
  #     posts = posts.where(place:params[:selected_place])
  #   end

  #   @post_keyword = params[:post_keyword]
  #   @post_method = params[:post_method]
  #   if params[:post_keyword].present?
  #     posts = posts.merge(Post.post_search_for(@post_keyword, @post_method)).latest
  #   end
  # end

end
