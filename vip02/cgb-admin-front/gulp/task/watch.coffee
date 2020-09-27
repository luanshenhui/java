gulp = require "gulp"
config = require "../config"

gulp.task "watch", ->
  gulp.run "template", "buildjs", "copy", "views", "images", "styles", "rev"
  gulp.watch config.coffee.src, ["build"] ##监控javascript改变
  gulp.watch config.styles.watch, ["build"]
  gulp.watch [config.views.src, config.components.src], ["build"]
  gulp.watch config.templates.src, ["build"]
