import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["collapsedContent", "expandedContent"];
  static open;
  static originalContent;

  static values = {
    showMoreText: String,
    showLessText: String
  };

  initialize() {
    this.toggle = this.toggle.bind(this);
  }

  connect() {
    this.open = false;
    this.originalContent = this.collapsedContentTarget.innerHTML;
  }

  toggle(event) {
    this.open === false ? this.show(event) : this.hide(event);
  }

  show(event) {
    this.open = true;

    event.target.innerHTML = this.showLessTextValue;
    this.collapsedContentTarget.innerHTML = this.expandedContentTarget.innerHTML;
  }

  hide(event) {
    this.open = false;

    event.target.innerHTML = this.showMoreTextValue;
    this.collapsedContentTarget.innerHTML = this.originalContent;
  }
}
