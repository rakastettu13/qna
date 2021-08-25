class AchievementsController < ApplicationController
  before_action :authenticate_user!, only: :received

  expose :achievements, -> { Achievement.all }

  def received
    render current_user.achievements
  end
end
