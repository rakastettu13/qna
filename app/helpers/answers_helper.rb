module AnswersHelper
  def link_to_best(answer)
    return unless answer.persisted?

    link_to 'Best',
            best_answer_path(answer),
            method: :patch,
            remote: true,
            class: 'best-link hidden'
  end
end
