class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js { head :forbidden }
      format.json { render json: exception.message, status: :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  check_authorization unless: :devise_controller?
end
