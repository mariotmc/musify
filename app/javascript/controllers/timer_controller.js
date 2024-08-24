import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timerDisplay", "image"];
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
      this.unblurImage(timeLeft);
      this.updateHint(timeLeft);
    } else {
      this.timerDisplayTarget.textContent = "0";
      clearInterval(this.timerInterval);
    }
  }

  unblurImage(timeLeft) {
    if (timeLeft <= 10) {
      if (this.imageTarget.classList.contains("blur-md")) this.imageTarget.classList.remove("blur-md");
      if (!this.imageTarget.classList.contains("blur-sm")) this.imageTarget.classList.add("blur-sm");
    } else if (timeLeft <= 20) {
      if (this.imageTarget.classList.contains("blur-md")) this.imageTarget.classList.remove("blur-md");
      if (!this.imageTarget.classList.contains("blur")) this.imageTarget.classList.add("blur");
    } else {
      if (!this.imageTarget.classList.contains("blur-md")) this.imageTarget.classList.add("blur-md");
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
