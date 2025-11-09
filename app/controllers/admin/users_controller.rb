class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
        @user.destroy
        redirect_to admin_root_path, notice: 'ユーザーを削除しました。'
  end
end
