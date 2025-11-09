class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'
  
  def index
  end

  def destroy
  end
end
