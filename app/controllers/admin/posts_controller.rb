class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
    @posts = Post.all.page(params[:page])
  end

  def destroy
    @posts = Post.find(params[:id])
    @posts.destroy
    redirect_to request.referer, notice: '投稿を削除しました'
  end
end
