import {EditingHelper} from 'utilities/editing_helper';
import {showAllFor} from "utilities/links_handler.js";

$(document).on("turbolinks:load", () => {
  EditingHelper.call($('.answers'))
});

$(document).on("turbolinks:load ajax:success", () => {
  showAllFor($(`.answer-author-${gon.user_id}`))
});
