gulp = require "gulp"
concat = require 'gulp-concat'
uglify = require "gulp-uglify"

gulp.task "copy", ->
  gulp.src "libs/*.js"
  .pipe concat "spirit.js"
    .pipe uglify()
    .pipe gulp.dest "build/assets/scripts"

