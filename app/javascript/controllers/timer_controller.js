import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timerDisplay", "progressCircle", "image"];
  static values = { endTime: Number };
  static outlets = ["hint"];

  connect() {
    this.startCountdown(this.endTimeValue);

    this.element.addEventListener("turbo:stream-update", (e) => {
      const serverEndTime = parseInt(e.detail.content);
      this.startCountdown(serverEndTime);
    });
  }

  startCountdown(endTime) {
    clearInterval(this.interval);

    this.interval = setInterval(() => {
      const now = Date.now();
      const timeLeft = Math.max(0, endTime - now);
      const secondsLeft = Math.ceil(timeLeft / 1000);

      this.timerDisplayTarget.textContent = secondsLeft;

      const progress = timeLeft / 30000;
      const dashoffset = 251.2 * (1 - progress);
      this.progressCircleTarget.style.strokeDashoffset = dashoffset;

      if (secondsLeft > 20) {
        this.progressCircleTarget.classList.remove("stroke-orange-500", "stroke-red-500");
        this.progressCircleTarget.classList.add("stroke-yellow-500");
      } else if (secondsLeft > 10) {
        this.progressCircleTarget.classList.remove("stroke-yellow-500", "stroke-red-500");
        this.progressCircleTarget.classList.add("stroke-orange-500");
      } else {
        this.progressCircleTarget.classList.remove("stroke-yellow-500", "stroke-orange-500");
        this.progressCircleTarget.classList.add("stroke-red-500");
      }

      if (timeLeft <= 0) {
        clearInterval(this.interval);
      }
    }, 100);
  }

  disconnect() {
    clearInterval(this.interval);
  }
}
