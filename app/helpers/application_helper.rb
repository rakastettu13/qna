module ApplicationHelper
  def link_to_delete(elem)
    return unless elem.persisted? && current_user&.author_of?(elem)

    link_to "Delete the #{elem.class.to_s.downcase}",
            polymorphic_path(elem),
            method: :delete
  end

  def link_to_edit(elem)
    return unless elem.persisted? && current_user&.author_of?(elem)

    link_to "Edit the #{elem.class.to_s.downcase}",
            '#',
            class: 'edit-link',
            data: { id: elem.id }
  end
end
