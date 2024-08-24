import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timerDisplay"];
  static values = { endTime: Number };
  static outlets = ["hint"];

  connect() {
    this.updateTimer();
    this.timerInterval = setInterval(() => this.updateTimer(), 1000);
  }

  disconnect() {
    clearInterval(this.timerInterval);
  }

  updateTimer() {
    const currentTime = Math.floor(Date.now() / 1000);
    const timeLeft = this.endTimeValue - currentTime;

    if (timeLeft >= 0) {
      this.timerDisplayTarget.textContent = timeLeft;
      this.updateHint(timeLeft);
    } else {
      this.timerDisplayTarget.textContent = "0";
      clearInterval(this.timerInterval);
    }
  }

  updateHint(timeLeft) {
    if (this.hasHintOutlet) {
      if (timeLeft <= 10) {
        this.hintOutlet.showBothLettersHint();
      } else if (timeLeft <= 20) {
        this.hintOutlet.showFirstLetterHint();
      } else {
        this.hintOutlet.showInitialHint();
      }
    }
  }
}
