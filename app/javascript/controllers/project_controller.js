import {
  Controller
} from "stimulus"

export default class extends Controller {
  static targets = ["hours", "amount"]

  connect() {
    this.load()
  }

  load() {
    fetch(this.data.get("url"), {
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": getMetaValue("csrf-token")
      }
    }).then(response => response.text())
      .then(response => {
        const json = JSON.parse(response)

        this.hoursTarget.innerHTML = json.hours
        this.amountTarget.innerHTML = json.amount
      })
  }
}

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}
