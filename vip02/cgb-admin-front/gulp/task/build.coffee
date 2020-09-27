gulp = require "gulp"
sequence = require "gulp-sequence"

gulp.task "build", sequence "clean", "template", "buildjs", "copy", "images", "styles", "views", "rev"