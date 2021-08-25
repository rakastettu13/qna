class AchievementsController < ApplicationController
  expose :achievements, -> { Achievement.all }
end
