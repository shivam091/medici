import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["target", "template"];

  static values = {
    wrapperSelector: {
      type: String,
      default: ".nested-form-wrapper"
    }
  };

  initialize() {
    this.addAssociation = this.addAssociation.bind(this);
    this.removeAssociation = this.removeAssociation.bind(this);
  }

  addAssociation(event) {
    event.preventDefault();
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString());
    this.targetTarget.insertAdjacentHTML("beforebegin", content);
  }

  removeAssociation(event) {
    event.preventDefault();

    const wrapper = event.target.closest(this.wrapperSelectorValue);

    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove();
    } else {
      wrapper.style.cssText = "display: none !important;";
      wrapper.querySelector("input[name*='_destroy']").value = 1;
    }
  }
}
