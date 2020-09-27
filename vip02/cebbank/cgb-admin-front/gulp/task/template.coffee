gulp = require "gulp"
handlebars = require "gulp-handlebars"
wrap = require "gulp-wrap"
declare = require "gulp-declare"
concat = require "gulp-concat"
emberEmblem = require 'gulp-ember-emblem'
defineModule = require 'gulp-define-module'
hbs = require  "handlebars"
plumber = require('gulp-plumber')
config = require "../config"

gulp.task "template", ->
  gulp.src config.templates.src
  .pipe handlebars({handlebars:hbs})
    .pipe wrap "Handlebars.template(<%= contents %>)"
      .pipe declare
          namespace: config.templates.namespace
          noRedeclare: true
          processName: (filePath) ->
            declare.processNameByPath(filePath.replace('app\\components\\', ''))
        .pipe concat config.templates.build
          .pipe gulp.dest config.templates.dest
