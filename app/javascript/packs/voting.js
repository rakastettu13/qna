$(document).on("turbolinks:load", () => {
  $('.voting').on('ajax:success', (event) => {
    $('.rating').text(event.detail[0])
    $('.voting-link').each((index, link) => {link.remove()})
  })

  $('.voting').on('ajax:error', (event) => {
    $('.voting-errors').html(event.detail[0].error)
  })
});
