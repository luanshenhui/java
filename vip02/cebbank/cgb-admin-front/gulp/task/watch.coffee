gulp = require "gulp"
config = require "../config"

gulp.task "watch", ->
  gulp.run "buildjs", "styles","views"
  gulp.watch config.coffee.src, ["buildjs"] ##监控javascript改变
  gulp.watch config.styles.watch, ["styles"]
  gulp.watch [config.views.src, config.components.src], ["views"]
