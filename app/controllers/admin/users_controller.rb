class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
  end

  def show
  end

  def destroy
  end
end
