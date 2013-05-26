class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def ban_pages
    redirect_to "/amas/new"
  end
  
end
