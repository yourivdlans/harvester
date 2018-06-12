import {
  Controller
} from "stimulus"

export default class extends Controller {
  connect() {
    this.load()
  }

  load() {
    fetch(this.data.get("url"), {
      credentials: "same-origin"
    }).then(response => response.text())
      .then(html => {
        this.element.innerHTML = html
      })
  }
}
