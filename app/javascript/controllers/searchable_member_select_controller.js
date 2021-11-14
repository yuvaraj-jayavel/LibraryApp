import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"
import _ from "lodash"

// Connects to data-controller="searchable-member-select"
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
    return _.map(responseItems, (member) => {
      const id = _.get(member, 'id', '')
      const personalNumber = _.get(member, 'personal_number', '')
      const name = _.get(member, 'name', '')

      return {
        id: id,
        text: `${id} | ${personalNumber} - ${name}`
      }
    })
  }
}
