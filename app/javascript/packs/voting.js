$(document).on("turbolinks:load", () => {
  $('.voting').on('ajax:success', (event) => {
    $('.rating').text(event.detail[0])
    
    if(event.target.dataset.method == "patch") {
    $('.voting-link').each((index, link) => {link.classList.add('hidden')})
    $('.cancel-link')[0].classList.remove('hidden')
  } else {
    $('.voting-link').each((index, link) => {link.classList.remove('hidden')})
    $('.cancel-link')[0].classList.add('hidden')
  }
  })

  $('.voting').on('ajax:error', (event) => {
    $('.voting-errors').html(event.detail[0].error)
  })
});
