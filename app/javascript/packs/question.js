import {EditingHelper} from 'utilities/editing_helper';

$(document).on("turbolinks:load", () => {
  EditingHelper.call($('.show-question'))
});
