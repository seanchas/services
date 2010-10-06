class WelcomeController < ApplicationController
  
  def index
    redirect_to :services
  end
  
  def unauthenticated
    redirect_to :root
  end
  
end
