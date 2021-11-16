module.exports = {
  mode: 'jit',
  purge: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        'sans': ['"Nunito Sans"', 'ui-sans-serif', 'system-ui']
      },
      minHeight: (theme) => ({
        ...theme('spacing')
      }),
      minWidth: (theme) => ({
        ...theme('spacing')
      })
    }
  }
}
