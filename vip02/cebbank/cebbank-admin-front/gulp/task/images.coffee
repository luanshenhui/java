gulp = require "gulp"
cssspriter = require 'gulp-css-spriter'
spritesmith = require 'gulp.spritesmith'
gulpif = require "gulp-if"

gulp.task 'images', ->
  gulp.src 'app/images/**/*.png'
  .pipe spritesmith
      imgName: "sprite.png"
      cssName: "sprite.css"
      imgPath: '/static/images/sprite.png'
    .pipe gulpif "*.png", gulp.dest "build/static/images"
      .pipe gulpif "*.css", gulp.dest 'libs'
