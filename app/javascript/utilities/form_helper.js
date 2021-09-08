export class FormHelper {
  static call(resources, action) {
    resources.on('click', `.${action}-link`, () => {
      event.preventDefault();
      const helper = new FormHelper(event.target.dataset.id, action);

      helper.showForm();

      helper.form.on('submit', () => {
        helper.hideForm()
      });
   });
  }

  constructor(id, action) {
    this.link = $(`*[data-id="${id}"]`)
    this.form = $(`.${action}-${id}`)
  }

  showForm() {
    this.link.addClass('hidden')
    this.form.removeClass('hidden')
  }

  hideForm() {
    this.link.removeClass('hidden')
    this.form.addClass('hidden')
  }
}
