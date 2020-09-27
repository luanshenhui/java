gulp = require "gulp"
clean = require "gulp-clean"
config = require "../config"

gulp.task "clean", ->
  gulp.src [config.views.dist, config.styles.dist, config.coffee.dist]
  .pipe clean()