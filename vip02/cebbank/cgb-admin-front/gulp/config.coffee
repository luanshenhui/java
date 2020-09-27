module.exports =

  coffee:
    src: ["app/components/**/*.coffee"]
    dist: "build/assets/scripts"
    name: "app.js"
    libs: ["libs/*.js"]

  styles:
    src: ["app/styles/app.scss"]
    watch: ["app/styles/app.scss","app/components/**/*.scss"]
    dist: "build/assets/styles"

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
    dest: "libs"