import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timerDisplay", "progressCircle"];
  static values = { endTime: Number };

  connect() {
    this.timerInterval = setInterval(() => this.updateTimer(), 50);
  }

  disconnect() {
    clearInterval(this.timerInterval);
  }

  updateTimer() {
    const now = Date.now() / 1000;
    const timeLeft = Math.max(0, this.endTimeValue - now);

    this.timerDisplayTarget.textContent = Math.ceil(timeLeft);

    const progress = timeLeft / 30;
    const dashoffset = 251.2 * (1 - progress);
    this.progressCircleTarget.style.strokeDashoffset = dashoffset;

    this.updateColor(timeLeft);

    if (timeLeft <= 0) {
      clearInterval(this.timerInterval);
    }
  }

  updateColor(timeLeft) {
    const colors = ["yellow-500", "orange-500", "red-500"];
    let colorIndex = 0;

    if (timeLeft <= 20 && timeLeft > 10) {
      colorIndex = 1;
    } else if (timeLeft <= 10) {
      colorIndex = 2;
    }

    this.progressCircleTarget.classList.remove(...colors.map((c) => `text-${c}`));
    this.progressCircleTarget.classList.add(`text-${colors[colorIndex]}`);
  }
}
