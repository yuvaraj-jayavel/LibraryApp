import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = [ 'form', 'text' ]

  connect() {
  }

  reset(e) {
    e.preventDefault()
    for (const textTarget of this.textTargets) {
      textTarget.value = ''
    }
    this.formTarget.submit()
  }
}
