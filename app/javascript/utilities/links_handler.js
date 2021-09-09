export function showAll(object) {
  object.each((index, link) => { link.classList.remove('hidden') })
}

export function hideAll(object) {
  object.each((index, link) => { link.classList.add('hidden') })
}

export function showAllFor(resource) {
  resource.each((link, div) => {
    showAll($(div).find('.edit-link, .delete-link, .delete-file'))
  })
}
