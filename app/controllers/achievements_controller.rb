class AchievementsController < ApplicationController
  before_action :authenticate_user!, only: :received

  expose :achievements, -> { Achievement.all }
end
