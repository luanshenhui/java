gulp = require "gulp"
coffee = require "gulp-coffee"
gulputil = require "gulp-util"
seajswrap = require 'gulp-seajs-wrap'
seajstransport = require 'gulp-seajs-transport'
addsrc = require 'gulp-add-src'
order = require 'gulp-order'
concat = require 'gulp-concat'
rev = require "gulp-rev"
uglify = require "gulp-uglify"
config = require "../config"

gulp.task 'buildjs', ->
  gulp.src config.coffee.src, {base: 'app/components'}
  .pipe addsrc "app/scripts/**/*.coffee", {base: "app/scripts"}
    .pipe coffee()
      .pipe seajswrap()
        .pipe seajstransport()
          #.pipe order config.coffee.order, {base: "scripts"}
          .pipe concat config.coffee.name
            #.pipe uglify()
              #.pipe rev()
              .pipe gulp.dest config.coffee.dist

