module ApplicationHelper
  def link_to_delete(resource)
    link_to "Delete the #{resource.class.to_s.downcase}",
            polymorphic_path(resource),
            class: 'delete-link hidden',
            method: :delete,
            remote: true
  end

  def link_to_edit(resource)
    link_to "Edit the #{resource.class.to_s.downcase}",
            '#',
            class: 'edit-link hidden',
            data: { id: resource.id }
  end

  def links_to_files(resource)
    return unless resource.files.attached?

    resource.files.each do |file|
      concat link_to(file.filename.to_s, file, target: 'blank', rel: 'nofollow', class: "file-#{file.id}")
      concat link_to("\u274c", attachment_path(file), method: :delete, remote: true,
                                                      class: "delete-file file-#{file.id} hidden")
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

  def voting_links(resource, current_user)
    return rating(resource) unless current_user

    if can? :change_rating, resource
      voting(resource)
    elsif can? :cancel, resource
      cancel(resource)
    else
      rating(resource)
    end
  end

  private

  def cancel(resource)
    concat link_to '+', polymorphic_path([:change_rating, resource], point: +1),
                   method: :patch, remote: true, data: { type: :json }, class: 'voting-link hidden'

    rating(resource)

    concat link_to '–', polymorphic_path([:change_rating, resource], point: -1),
                   method: :patch, remote: true, data: { type: :json }, class: 'voting-link hidden'

    concat link_to 'cancel', polymorphic_path([:cancel, resource]),
                   method: :delete, remote: true, data: { type: :json }, class: 'cancel-link'
  end

  def voting(resource)
    concat link_to '+', polymorphic_path([:change_rating, resource], point: +1),
                   method: :patch, remote: true, data: { type: :json }, class: 'voting-link'

    rating(resource)

    concat link_to '–', polymorphic_path([:change_rating, resource], point: -1),
                   method: :patch, remote: true, data: { type: :json }, class: 'voting-link'

    concat link_to 'cancel', polymorphic_path([:cancel, resource]),
                   method: :delete, remote: true, data: { type: :json }, class: 'cancel-link hidden'
  end

  def rating(resource)
    concat content_tag :span, resource.rating, class: 'rating'
  end
end
