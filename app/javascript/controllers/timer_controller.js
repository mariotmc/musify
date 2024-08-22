import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timerDisplay"];
  static values = { endTime: Number };

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
    } else {
      this.timerDisplayTarget.textContent = "0";
      clearInterval(this.timerInterval);
    }
  }
}
