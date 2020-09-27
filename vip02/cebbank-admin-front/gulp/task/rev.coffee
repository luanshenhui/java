gulp = require "gulp"
revcollector = require "gulp-rev-collector"
config = require "../config"

gulp.task "rev", ->
  gulp.src config.rev.params
    .pipe revcollector
      "replaceReved": true
    .pipe gulp.dest config.views.dist

