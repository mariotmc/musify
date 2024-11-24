import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["option", "input"];

  select(event) {
    this.optionTargets.forEach((option) => option.classList.remove("ring-2", "ring-black"));

    event.currentTarget.classList.add("ring-2", "ring-black");
    this.inputTarget.value = event.currentTarget.dataset.avatar;
  }
}
