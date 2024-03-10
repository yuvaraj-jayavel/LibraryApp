import {fetchJson} from "../utils/fetch_utils";

export const tomSelectLoad = (query, callback, filterParams, baseUrl, transformDataFn) => {
  if (!query) return callback()

  fetchJson(baseUrl, { params: {...filterParams, search: query} })
    .then(responseItems => transformDataFn(responseItems))
    .then(items => callback(items))
    .catch(() => callback())
}
