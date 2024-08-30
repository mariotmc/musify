import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["option", "input"];

  connect() {
    console.log("Avatar selection controller connected");
  }

  select(event) {
    this.optionTargets.forEach((option) => option.classList.remove("ring-2", "ring-black"));

    event.currentTarget.classList.add("ring-2", "ring-black");

    const avatarName = event.currentTarget.dataset.avatar;

    fetch(`/assets/avatars/${avatarName}.png`)
      .then((response) => response.blob())
      .then((blob) => {
        const file = new File([blob], `${avatarName}.png`, { type: "image/png" });
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        this.inputTarget.files = dataTransfer.files;
      });
  }
}
