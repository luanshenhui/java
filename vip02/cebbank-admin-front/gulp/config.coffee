module.exports =

  coffee:
    src: ["app/components/**/*.coffee"]
    watch: ["app/scripts/**/*.coffee","app/components/**/*.coffee"]
    dist: "build/static/scripts"
    name: "app.js"
    libs: ["libs/*.js"]

  styles:
    src: ["app/styles/*.styl","app/components/**/*.styl"]
    watch: ["app/styles/*.styl","app/components/**/*.styl"]
    dist: "build/static/styles"

  views:
    src: ["app/views/**/*.hbs"]
    dist: "build/views"

  components:
    src: ["app/components/**/view.hbs"]
    dist: "build/components"

  templates:
    src: ["app/components/**/templates/*.hbs"]
    namespace: "App.templates"
    build: "template.js"
    dest: "temp"

  rev:
    params: ["temp/rev/*.json", "app/views/**/*layout.hbs","libs/*.css"]
    dist: "temp/rev"