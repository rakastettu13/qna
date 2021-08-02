module QuestionsHelper
  def link_to_delete(question)
    if question.author == current_user
      link_to 'Delete the question',
              question_path(question),
              method: :delete
    end
  end
end
