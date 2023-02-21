import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["selectAllCheckbox", "checkbox", "count"];

  initialize() {
    this.toggle = this.toggle.bind(this);
    this.refresh = this.refresh.bind(this);
  }

  connect() {
    if (!this.hasSelectAllCheckboxTarget) {
      return;
    }

    this.selectAllCheckboxTarget.addEventListener("change", (event) => this.toggle(event));
    this.checkboxTargets.forEach(checkbox => checkbox.addEventListener("change", (event) => this.refresh()));
    this.refresh();
  }

  disconnect() {
    if (!this.hasSelectAllCheckboxTarget) {
      return;
    }

    this.selectAllCheckboxTarget.removeEventListener("change", (event) => this.toggle(event));
    this.checkboxTargets.forEach(checkbox => checkbox.removeEventListener("change", (event) => this.refresh()));
  }

  toggle(event) {
    event.preventDefault();

    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = event.target.checked;
      this.triggerInputEvent(checkbox);
    });
    this.setCount();
  }

  refresh() {
    const checkboxesCount = this.checkboxTargets.length;
    const checkboxesCheckedCount = this.checked.length;

    this.selectAllCheckboxTarget.checked = (checkboxesCheckedCount > 0);
    this.selectAllCheckboxTarget.indeterminate = (checkboxesCheckedCount > 0 && checkboxesCheckedCount < checkboxesCount);
    this.setCount();
  }

  setCount() {
    if (this.hasCountTarget) {
      const count = this.checked.length;
      this.countTarget.textContent = `${count} selected`;
    }
  }

  triggerInputEvent(checkbox) {
    const event = new Event("input", {bubbles: false, cancelable: true});

    checkbox.dispatchEvent(event);
  }

  get checked() {
    return this.checkboxTargets.filter((checkbox) => checkbox.checked);
  }

  get unchecked() {
    return this.checkboxTargets.filter((checkbox) => !checkbox.checked);
  }
}
