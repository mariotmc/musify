import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.element.addEventListener("keypress", this.submitOnEnter.bind(this));
  }

  submitOnEnter(event) {
    if (event.key === "Enter") {
      event.preventDefault();
      this.element.requestSubmit();
      this.clearInput();
    }
  }

  clearInput() {
    this.inputTarget.value = "";
  }
}
