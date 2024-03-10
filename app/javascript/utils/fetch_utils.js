import _ from "lodash"

export const fetchJson = async (baseUrl, options = {}) => {
  const params = new URLSearchParams(_.get(options, 'params', {}))
  const url = `${baseUrl}?${params}`
  return fetch(url, { headers: { 'Accept': 'application/json' }})
    .then(response => response.json())
}
