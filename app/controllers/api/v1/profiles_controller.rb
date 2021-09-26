class Api::V1::ProfilesController < Api::V1::BaseController
  def index
    @users = User.all.excluding(current_resource_owner)
    authorize! :index, @users
    render json: @users, serializer_each: UserSerializer
  end

  def me
    authorize! :me, current_resource_owner
    render json: current_resource_owner, serializer: UserSerializer
  end
end
