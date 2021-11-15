import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"
import _ from "lodash"
import {tomSelectLoad} from "../utils/tom_select";

// Connects to data-controller="searchable-member-select"
export default class extends Controller {
  static values = { url: String, filterParams: Object }

  // TODO: DRY this controller. Duplicated from searchable_book_select_controller
  connect() {
    new TomSelect(this.element, {
      valueField: 'id',
      searchField: ['text'],
      load: (query, callback) => tomSelectLoad(query, callback, this.filterParamsValue,
                                                                    this.urlValue, this.transformData)
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
