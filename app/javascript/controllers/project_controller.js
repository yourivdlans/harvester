import {
  Controller
} from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }
  static targets = ["hours", "amount", "invoiceState", "setInvoiced", "setArchived"]

  connect() {
    this.load()
  }

  load() {
    fetch(this.urlValue, {
      credentials: "same-origin"
    }).then(response => response.text())
      .then(html => {
        this.element.innerHTML = html
      })
  }

  archive(event) {
    event.preventDefault()

    fetch(this.urlValue, {
      method: "DELETE",
      dataType: "script",
      credentials: "include",
      headers: {
        "X-CSRF-Token": getMetaValue("csrf-token")
      },
    }).then(response => {
      if (response.ok == true) {
        this.element.parentNode.removeChild(this.element)
      }
    })
  }

  refresh(event) {
    event.preventDefault()

    this.load()
  }
}

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}
