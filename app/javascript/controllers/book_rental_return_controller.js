import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="book-rental-return"
export default class extends Controller {
  static targets = [ 'fine' ]

  connect() {
  }

  handleChecked(event) {
    const fine = Number(this.fineTarget.innerText)
    const fineChange = event.currentTarget.checked ? fine : -fine
    const customEvent = new CustomEvent('changed', { detail: { fine: fineChange } })
    this.element.dispatchEvent(customEvent)
  }
}
