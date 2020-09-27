gulp = require "gulp"
config = require "../config"

gulp.task "views", ->
  #views
  gulp.src config.views.src
  .pipe gulp.dest config.views.dist
  #组件
  gulp.src config.components.src
  .pipe gulp.dest config.components.dist
