import consumer from "./consumer"
import {showAllFor} from "utilities/links_handler.js";

consumer.subscriptions.create({ channel: "QuestionChannel", id: gon.question_id }, {
  received(data) {
    $(`.${data.css}`).append(data.template)
    showAllFor($(`.answer-author-${gon.user_id}`));
  },
});
