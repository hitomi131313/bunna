class UsersController < ApplicationController

before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to mypage_path(@user)
  end

  def mypage
    @user = current_user
    @my_post = @user.posts.all
    #@following_posts = Post.where(user_id: @user.following_ids).all
  end


private
  def user_params
    params.require(:user).permit(:name, :last_name, :first_name, :last_name_kana, :first_name_kana, :email, :passward)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to posts_path
    end
  end

end
