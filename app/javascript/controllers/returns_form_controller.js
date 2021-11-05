import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="returns-form"
export default class extends Controller {
  static targets = [ 'booksList' ]
  static values = { url: String }

  connect() {
    console.log('First controllerss')
    this.loadMemberBookRentals()
  }

  handleMemberIdChange(event) {
    this.loadMemberBookRentals(event.target.value)
  }

  loadMemberBookRentals(memberId = null) {
    fetch(`${this.urlValue}?member_id=${memberId}`)
      .then(response => response.text())
      .then(html => this.booksListTarget.innerHTML = html)
  }
}
