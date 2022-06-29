class ApplicationController < ActionController::Base
 before_action :configure_permitted_parameters, if: :devise_controller?
 before_action :authenticate_user!
 protect_from_forgery with: :exception
 helper_method :current_cart

  def current_cart
    if current_user
      # ユーザーとカートの紐付け
      current_cart = current_user.cart || current_user.create_cart!
    else
      # セッションとカートの紐付け
      current_cart = Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] ||= current_cart.id
    end
    current_cart
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:company_address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:company_address])
  end
end
