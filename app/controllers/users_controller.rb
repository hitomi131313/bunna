class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show]
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
    @my_post = @user.posts.all
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
