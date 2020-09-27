gulp = require "gulp"
revcollector = require "gulp-rev-collector"
config = require "../config"

gulp.task "image-rev", ->
  gulp.src ["temp/rev/*.json", "sprite/*.css"]
    .pipe revcollector
        "replaceReved": true
    .pipe gulp.dest "libs"
