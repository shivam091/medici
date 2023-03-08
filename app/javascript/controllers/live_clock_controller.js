import { Controller } from "@hotwired/stimulus";
import moment from "moment";

export default class extends Controller {

  static targets = ["date", "time"];

  initialize() {
    this.updateClock = this.updateClock.bind(this);
  }

  connect() {
    setInterval(() => {
      this.updateClock();
    }, 500);
  }

  updateClock() {
    var $momentObject = new moment();
    this.dateTarget.innerHTML = $momentObject.format("ddd MM/DD/y")
    this.timeTarget.innerHTML = $momentObject.format("H:mm:ss")
  }
}
