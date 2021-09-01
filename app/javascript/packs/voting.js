$(document).on("turbolinks:load", () => {
  $('.voting').each((index, div) => {
    const voting =  $(div)

    voting.on('ajax:success', (event) => {
      voting.find('.rating').text(event.detail[0])

      if(event.target.dataset.method == "patch") {
      voting.find('.voting-link').each((index, link) => {link.classList.add('hidden')})
      voting.find('.cancel-link')[0].classList.remove('hidden')
    } else {
      voting.find('.voting-link').each((index, link) => {link.classList.remove('hidden')})
      voting.find('.cancel-link')[0].classList.add('hidden')
    }
    })

    voting.on('ajax:error', (event) => {
      console.log(voting.find('.voting-errors'))
      voting.find('.voting-errors').html(event.detail[0].error)
    })
  })
});
