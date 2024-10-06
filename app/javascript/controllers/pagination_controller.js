import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pagination"
export default class extends Controller {
  connect() {
  }

  navigateToPage(e) {
    e.preventDefault();

    const selectedOption = e.currentTarget.options[e.currentTarget.selectedIndex];

    if (!selectedOption?.dataset?.url) {
      return;
    }
    const url = new URL(selectedOption?.dataset?.url, window.location.origin);
    window.location.href = url;
  }
}
