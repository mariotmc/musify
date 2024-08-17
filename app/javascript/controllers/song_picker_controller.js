import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["song"];

  connect() {
    for (const target of this.songTargets) {
      if (target.getElementsByTagName("input")[0].checked == true) {
        target.classList.add("selected-song");
      }
    }
  }

  selectSong(event) {
    for (const target of this.songTargets) {
      target.getElementsByTagName("input")[0].checked = false;
      target.classList.remove("selected-song");
    }

    event.currentTarget.classList.add("selected-song");
    event.currentTarget.getElementsByTagName("input")[0].checked = true;
  }
}
