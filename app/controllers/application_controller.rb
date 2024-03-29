class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_account

  def current_account
    current_user.account
  end

  def authenticate_facebook
    redirect_to root_url unless user_signed_in?
  end

  protected
    def after_sign_in_path_for(resource)
      origin_url = request.env['omniauth.origin']
      if request.referrer && request.referrer.gsub(/\?.*/, '') == landing_url
        '/close_tab'
      elsif origin_url && origin_url.include?('landing')
        logged_in_path
      elsif origin_url && origin_url.include?('preview')
        video_id = origin_url.match(/\/\d+/).to_s[1..-1]
        video_path(video_id)
      elsif origin_url && origin_url.include?('upload')
        new_video_path
      elsif origin_url
        origin_url
      else
        root_url
      end
    end

    def after_inactive_sign_up_path_for(resource)
      root_url
    end

    def after_sign_up_path_for(resource)
      root_url
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :paypal_email, :category])
      devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :paypal_email, :category])
    end
end
