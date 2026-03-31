class ApplicationController < ActionController::Base
  # Basic認証
  before_action :basic_auth

  # devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Basic認証
  def basic_auth
    return unless Rails.env.production?

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  # devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      key: [:nickname, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_date])
  end
end
