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
      concat link_to(file.filename.to_s, file, target: 'blank', rel: 'nofollow', class: "file-#{file.id}")

      if current_user&.author_of?(resource)
        concat link_to("\u274c", attachment_path(file), method: :delete, remote: true,
                                                        class: "delete-file file-#{file.id}")
      end

      concat ' '
    end
  end

  def attached_links(resource)
    resource.links.find_each do |link|
      concat content_tag(:li, link_to(link.name, link.url) + GistService.view(link))
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
