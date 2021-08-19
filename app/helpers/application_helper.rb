module ApplicationHelper
  def link_to_delete(resource)
    return unless resource.persisted? && current_user&.author_of?(resource)

    link_to "Delete the #{resource.class.to_s.downcase}",
            polymorphic_path(resource),
            class: 'delete-link',
            method: :delete,
            remote: true
  end

  def link_to_edit(resource)
    return unless resource.persisted? && current_user&.author_of?(resource)

    link_to "Edit the #{resource.class.to_s.downcase}",
            '#',
            class: 'edit-link',
            data: { id: resource.id }
  end

  def links_to_files(resource)
    return unless resource.files.attached?

    resource.files.each do |file|
      concat link_to(file.filename.to_s, file, target: 'blank', rel: 'nofollow')
      concat ' '
    end
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
