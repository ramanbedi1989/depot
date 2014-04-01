class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :authorize
  protect_from_forgery with: :exception

  private 
  def current_cart
  	begin
  		Cart.find(session[:cart_id])
  	rescue ActiveRecord::RecordNotFound
  		cart = Cart.create
  		session[:cart_id] = cart.id
  		cart
  	end
  end

  protected

  def authorize
    unless User.where(id: session[:user_id]).first
      redirect_to login_url, notice: "Please log in"
    end 
  end
end
