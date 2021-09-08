import {FormHelper} from 'utilities/form_helper';
import {showAll} from "utilities/links_handler.js";
import {showAllFor} from "utilities/links_handler.js";

$(document).on("turbolinks:load", () => {
  FormHelper.call($('.show-question, .answers'), 'edit')
  FormHelper.call($('.comments-cell'), 'create')

  const id = gon.user_id

  showAllFor($(`.question-author-${id}, .answer-author-${id}`));

  if($(`.question-author-${id}`)[0]) {
    showAll($('.best-link'))
  };

  $(document).on('ajax:error', (event) => {
    $(event.target.parentElement).find('.errors').html(event.detail[0])
  })

  $(document).on('ajax:success', (event) => {
    $(event.target).find('textarea').val('')
  })
});
