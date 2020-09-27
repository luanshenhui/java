gulp = require "gulp"
concat = require 'gulp-concat'
uglify = require "gulp-uglify"
order = require "gulp-order"
rev = require "gulp-rev"
config = require "../config"

gulp.task "copy", ->
  gulp.src "libs/*.js"
  .pipe order ["spirit.js", "multiselect.js"]
  .pipe concat "spirit.js"
  .pipe rev()
  .pipe uglify()
  .pipe gulp.dest "build/static/scripts"
  .pipe rev.manifest "rev-spirit-js.json"
  .pipe gulp.dest config.rev.dist
  gulp.src "libs/ztreeImg/**/*.*"
  .pipe gulp.dest "build/static/images/ztreeImg"
  gulp.src "libs/umeditor/**/*.*"
  .pipe gulp.dest "build/static/umeditor"
  gulp.src "libs/echarts/**/*.*"
  .pipe gulp.dest "build/static/echarts"
  gulp.src "libs/encrypt/**"
  .pipe gulp.dest "build/static/scripts/encrypt"
  gulp.src "libs/ajaxfileupload/**"
  .pipe gulp.dest "build/static/scripts/file"
  gulp.src "libs/laydate/**"
  .pipe gulp.dest "build/static/scripts/laydate"
  gulp.src "libs/fonts/**"
  .pipe gulp.dest "build/static/styles/fonts"



