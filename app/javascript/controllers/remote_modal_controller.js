import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    let backdrop = document.querySelector(".modal-backdrop");
    if (backdrop) {
      backdrop.remove();
    }

    this.modal = bootstrap.Modal.getOrCreateInstance(this.element, {
      focus: true,
      keyboard: false,
      backdrop: "static"
    });
    this.show();
  }

  disconnect() {
    this.hide();
  }

  hideBeforeRender(event) {
    if (this.isOpen()) {
      event.preventDefault()
      this.element.addEventListener("hidden.bs.modal", event.detail.resume)
      this.hide();
    }
  }

  show() {
    this.modal.show();
  }

  hide() {
    this.modal.hide();
    this.remoteModalTurboFrame.src = null;
  }

  isOpen() {
    this.element.classList.contains("show")
  }

  get remoteModalTurboFrame() {
    return document.querySelector("turbo-frame[id='remote_modal']")
  }
}
