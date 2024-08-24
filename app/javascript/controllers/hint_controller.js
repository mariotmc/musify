import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hintDisplay"];
  static values = {
    initialHint: String,
    firstLetterHint: String,
    bothLettersHint: String,
  };

  connect() {
    this.showInitialHint();
  }

  showInitialHint() {
    this.showHint(this.initialHintValue);
  }

  showFirstLetterHint() {
    this.showHint(this.firstLetterHintValue);
  }

  showBothLettersHint() {
    this.showHint(this.bothLettersHintValue);
  }

  showHint(hint) {
    this.hintDisplayTarget.textContent = hint;
  }
}
