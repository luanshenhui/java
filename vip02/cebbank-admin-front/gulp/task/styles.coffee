gulp = require "gulp"
#CSS3前缀
autoprefixer = require "gulp-autoprefixer"
minifycss = require "gulp-minify-css"
csso = require 'gulp-csso'
#CSS格式
csslint = require 'gulp-csslint'
concat = require "gulp-concat"
addsrc = require "gulp-add-src"
config = require "../config"
rev = require "gulp-rev"
stylus = require "gulp-stylus"

gulp.task "styles", ->
  gulp.src config.styles.src
  .pipe stylus()
  .pipe csslint()
#.pipe csslint.reporter()
  .pipe addsrc("libs/*.css")
  .pipe concat "app.css"
  .pipe minifycss()
  .pipe rev()
  .pipe gulp.dest config.styles.dist
  .pipe rev.manifest "rev-app-css.json"
  .pipe gulp.dest config.rev.dist
  gulp.src "libs/font/*.css"
  .pipe minifycss()
  .pipe rev()
  .pipe gulp.dest "build/static/styles/font"
  .pipe rev.manifest "rev-font-css.json"
  .pipe gulp.dest config.rev.dist
