class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js { head :forbidden }
      format.json { render json: exception.message, status: :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def render_errors(resource)
    render json: resource.errors.full_messages, status: :unprocessable_entity
  end
end
