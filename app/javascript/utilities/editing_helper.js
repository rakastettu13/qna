export class EditingHelper {
  static call(resources) {
    resources.on('click', '.edit-link', () => {
      event.preventDefault();
      const helper = new EditingHelper(event.target);

      helper.showForm();

      helper.form.on('submit', () => {
        helper.hideForm()
      });
   });
  }

  constructor(link) {
    this.link = link;
    this.form = $('.edit-' + $(link).data('id'));
  }

  showForm() {
    $(this.link).addClass('hidden');
    this.form.removeClass('hidden');
  }

  hideForm() {
    $(this.link).removeClass('hidden');
    this.form.remove();
  }
}
