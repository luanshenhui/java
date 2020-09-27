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
sass = require "gulp-sass"
rev = require "gulp-rev"
compass = require "gulp-for-compass"

gulp.task "styles", ->
  gulp.src config.styles.src
  .pipe sass()
    .pipe csslint()
      #.pipe csslint.reporter()
      .pipe addsrc("libs/*.css")
        .pipe concat "app.css"
          .pipe minifycss()
            #.pipe rev()
              .pipe gulp.dest config.styles.dist

