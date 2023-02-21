import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  connect() {
    this.autoFocus();
  }

  autoFocus() {
    this.element.focus();
    // Ensure that the cursor is placed at the end of the existing value.
    const value = this.element.value;
    this.element.value = "";
    this.element.value = value;
  }
}
