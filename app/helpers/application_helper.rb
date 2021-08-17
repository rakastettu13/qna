module ApplicationHelper
  def link_to_delete(elem)
    return unless elem.persisted? && current_user&.author_of?(elem)

    link_to "Delete the #{elem.class.to_s.downcase}",
            polymorphic_path(elem),
            class: 'delete-link',
            method: :delete,
            remote: true
  end

  def link_to_edit(elem)
    return unless elem.persisted? && current_user&.author_of?(elem)

    link_to "Edit the #{elem.class.to_s.downcase}",
            '#',
            class: 'edit-link',
            data: { id: elem.id }
  end

  def link_to_best(answer)
    return unless answer.persisted? && current_user&.author_of?(answer.question)

    link_to 'Best',
            best_answer_path(answer),
            method: :patch,
            remote: true
  end

  def user_links
    if current_user
      concat link_to 'Log out', destroy_user_session_path, method: :delete
    else
      concat link_to 'Log in', new_user_session_path
      concat ' '
      concat link_to 'Sign up', new_user_registration_path
    end
  end
end
