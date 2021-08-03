module ApplicationHelper
  def link_to_delete(elem)
    return unless elem.valid? && elem.author == current_user

    elem_class = elem.class.to_s.downcase

    link_to "Delete the #{elem_class}",
            send("#{elem_class}_path".to_sym, id: elem),
            method: :delete
  end
end
