class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    render json: exception.message, status: :forbidden
  end

  check_authorization unless: :devise_controller?
end
