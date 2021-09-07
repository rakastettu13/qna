class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions/#{params[:id]}"
  end
end
