export const tomSelectLoad = (query, callback, filterParams, baseUrl, transformDataFn) => {
  if (!query) return callback()

  const params = new URLSearchParams({...filterParams, search: query})
  const url = `${baseUrl}?` + params
  fetch(url, { headers: { 'Accept': 'application/json' }})
    .then(response => response.json())
    .then(responseItems => transformDataFn(responseItems))
    .then(items => callback(items))
    .catch(() => callback())
}