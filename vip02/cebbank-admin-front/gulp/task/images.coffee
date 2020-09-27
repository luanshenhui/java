gulp = require "gulp"
cssspriter = require 'gulp-css-spriter'
spritesmith = require 'gulp.spritesmith'
gulpif = require "gulp-if"
rev = require "gulp-rev"
config = require "../config"
revcollector = require "gulp-rev-collector"
gulpCssSpritesmith = require "gulp-css-spritesmith"

gulp.task 'images', ->
  gulp.src 'app/images/**/*.png'
    .pipe spritesmith
      imgName: "icons.png"
      cssName: "icons.css"
      imgPath: '/static/images/icons.png'
      cssTemplate:"app/styles/css.hbs"
    .pipe gulp.dest "sprite"

  gulp.src "sprite/*.png"
    .pipe rev()
    .pipe gulp.dest "build/static/images"
    .pipe rev.manifest "rev-app-image.json"
    .pipe gulp.dest config.rev.dist




