module.exports = {
  mode: 'jit',
  purge: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      minHeight: (theme) => ({
        ...theme('spacing')
      }),
      minWidth: (theme) => ({
        ...theme('spacing')
      })
    }
  }
}
