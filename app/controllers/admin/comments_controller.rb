class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'
  
  def index
    @comments = Comment.all
  end

  def destroy
  end
end
