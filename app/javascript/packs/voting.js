import {showAll} from "utilities/links_handler.js";
import {hideAll} from "utilities/links_handler.js";

$(document).on("turbolinks:load", () => {
  $('.voting').each((index, div) => {
    const voting =  $(div)

    voting.on('ajax:success', (event) => {
      voting.find('.rating').text(event.detail[0])

      if(event.target.dataset.method == "patch") {
      hideAll(voting.find('.voting-link'))
      showAll(voting.find('.cancel-link'))
    } else {
      showAll(voting.find('.voting-link'))
      hideAll(voting.find('.cancel-link'))
    }
    })

    voting.on('ajax:error', (event) => {
      voting.find('.voting-errors').html(event.detail[0].error)
    })
  })
});
