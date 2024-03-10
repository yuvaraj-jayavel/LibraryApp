import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="returns-form"
export default class extends Controller {
  static targets = [ 'booksList', 'totalFine' ]
  static values = { url: String, initialMemberId: Number }

  initialize() {
    this.memberId = this.initialMemberIdValue
    this.returningOn = new Date().toISOString().split('T')[0] // The date part of ISO String (e.g 2021-11-06)
    this.initializeTotalFine()
  }

  connect() {
    this.loadMemberBookRentals()
  }

  handleMemberIdChange(event) {
    this.memberId = event.target.value
    this.loadMemberBookRentals()
  }

  handleReturningDateChange(event) {
    this.returningOn = event.target.value
    this.loadMemberBookRentals()
  }

  handleFineChange(event) {
    const fineChange = event.detail.fine
    this.totalFine += fineChange
    this.totalFineTarget.innerHTML = this.totalFine.toFixed(2)
  }

  loadMemberBookRentals() {
    this.initializeTotalFine()
    fetch(`${this.urlValue}?member_id=${this.memberId}&returning_on=${this.returningOn}`)
      .then(response => response.text())
      .then(html => this.booksListTarget.innerHTML = html)
  }

  initializeTotalFine() {
    this.totalFine = 0
    this.totalFineTarget.innerHTML = this.totalFine.toFixed(2)
  }
}
