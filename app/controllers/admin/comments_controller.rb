class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'
  
  def index
    @comments = Comment.all
  end

  def destroy
    @comments = Comment.find(params[:id])
    @comments.destroy
    redirect_to request.referer, notice: 'コメントを削除しました'
  end
end
