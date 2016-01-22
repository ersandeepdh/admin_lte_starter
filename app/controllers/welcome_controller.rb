class WelcomeController < ApplicationController
  def index
  end

  def login
  	render :layout => false
  end

  def signup
  	render :layout => false
  end
end
