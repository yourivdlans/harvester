import {
  Controller
} from "stimulus"

export default class extends Controller {
  static targets = ["hours", "amount", "invoiceState", "setInvoiced", "setArchived"]

  connect() {
    this.load()
  }

  renderHours(hours) {
    return '<a target="_blank" href="'+this.data.get("detailed-time-report-url")+'">'+hours+'</a>';
  }

  renderInvoiceState(state) {
    return '<a target="_blank" href="' + this.data.get("moneybird-sales-invoice-url") + '">' + state + '</a>';
  }

  load() {
    fetch(this.data.get("url"), {
      credentials: "same-origin"
    }).then(response => response.text())
      .then(response => {
        const json = JSON.parse(response)

        this.hoursTarget.innerHTML = this.renderHours(json.hours)
        this.amountTarget.innerHTML = json.amount
        this.invoiceStateTarget.innerHTML = this.renderInvoiceState(this.data.get("invoice-state"))

        if (json.hours == "0" && this.data.get("invoice-state").toLowerCase() == "paid") {
          this.setArchivedTarget.classList.toggle("d-none")
        } else if (json.hours != "0" && !["unknown", "uninvoiced", "draft"].includes(this.data.get("invoice-state").toLowerCase())) {
          this.setInvoicedTarget.classList.toggle("d-none")
        }
      })
  }

  archive(event) {
    event.preventDefault()

    fetch(this.data.get("url"), {
      method: 'DELETE',
      dataType: 'script',
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
}

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}
