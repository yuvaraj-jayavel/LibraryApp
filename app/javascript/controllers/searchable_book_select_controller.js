import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"
import "tom-select/dist/css/tom-select.bootstrap5.min.css"
import _ from "lodash"

// Connects to data-controller="searchable-select"
export default class extends Controller {
  static values = { url: String }

  connect() {
    new TomSelect(this.element, {
      valueField: 'id',
      searchField: ['text'],
      load: (query, callback) => {
        if (!query) return callback()

        const url = `${this.urlValue}?search=${encodeURIComponent(query)}`
        fetch(url, { headers: { 'Accept': 'application/json' }})
          .then(response => response.json())
          .then(responseItems => this.transformData(responseItems))
          .then(items => callback(items))
          .catch(() => callback())
      },
    })
  }

  transformData(responseItems = {}) {
    return _.map(responseItems, (book) => {
      const name = _.get(book, 'name', '')
      const authorName = _.get(book, 'author.name', '')
      const id = _.get(book, 'id', '')

      return {
        id: id,
        text: `#${id} ${name} by ${authorName}`
      }
    })
  }
}
