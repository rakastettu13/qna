module AnswersHelper
  def link_to_best(answer)
    return unless answer.persisted? && current_user&.author_of?(answer.question)

    link_to 'Best',
            best_answer_path(answer),
            method: :patch,
            remote: true
  end
end
