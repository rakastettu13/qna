import consumer from "./consumer"

consumer.subscriptions.create({ channel: "QuestionChannel", id: gon.question_id }, {
  received(data) {
    $('.answers').append(data)
  },
});
