import {EditingHelper} from 'utilities/editing_helper';
import {showAll} from "utilities/links_handler.js";
import {showAllFor} from "utilities/links_handler.js";

$(document).on("turbolinks:load", () => {
  EditingHelper.call($('.show-question'))

  const question = $(`.question-author-${gon.user_id}`);

  showAllFor(question);

  if(question[0]) {
    showAll($('.best-link'))
  };

  $(document).on('ajax:error', (event) => {
    $(event.target.parentElement).find('.errors').html(event.detail[0])
  })

  $(document).on('ajax:success', (event) => {
    $(event.target).find('textarea').val('')
    console.log($(event.target).find('textarea'))
  })
});
