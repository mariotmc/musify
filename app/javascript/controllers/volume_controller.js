import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["slider", "audio", "percentage"];

  connect() {
    this.updateVolumeFromStorage();
    this.updateSliderBackground();
    this.updatePercentageDisplay();
  }

  audioTargetConnected(audioElement) {
    this.setInitialVolume(audioElement);
  }

  updateVolume() {
    const volume = this.sliderTarget.value;
    sessionStorage.setItem("volume", volume);
    this.setVolumeForAllAudio(volume);
    this.updateSliderBackground();
    this.updatePercentageDisplay();
  }

  updateSliderBackground() {
    const percent =
      ((this.sliderTarget.value - this.sliderTarget.min) / (this.sliderTarget.max - this.sliderTarget.min)) * 100;
    this.sliderTarget.style.background = `linear-gradient(to right, var(--range-fill) ${percent}%, var(--range-bg) ${percent}%)`;
  }

  updatePercentageDisplay() {
    this.percentageTarget.textContent = `${this.sliderTarget.value}%`;
  }

  updateVolumeFromStorage() {
    const storedVolume = sessionStorage.getItem("volume");
    if (storedVolume) {
      this.sliderTarget.value = storedVolume;
    }
  }

  setInitialVolume(audioElement) {
    const volume = this.sliderTarget.value;
    audioElement.volume = volume / 100;
  }

  setVolumeForAllAudio(volume) {
    this.audioTargets.forEach((audio) => {
      audio.volume = volume / 100;
    });
  }
}
