export class CreatingHelper {
  static call(resources) {
    resources.on('click', '.create-link', () => {
      event.preventDefault();
      const helper = new CreatingHelper(event.target.dataset.id);
      helper.showForm();
      $(`.create-${helper.id}`).on('submit', () => {
        helper.hideForm()
      });
   });
  }

  constructor(id) {
    this.id = id
  }

  showForm() {
    $(`.${this.id}`).hide()
    $(`.create-${this.id}`).removeClass('hidden')
  }

  hideForm() {
    $(`.${this.id}`).show()
    $(`.create-${this.id}`).addClass('hidden')
  }
}
