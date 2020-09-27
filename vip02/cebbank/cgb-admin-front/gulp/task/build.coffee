gulp = require "gulp"
sequence = require "gulp-sequence"

gulp.task "build", sequence "clean", "buildjs", "template", "copy", "views", "images", "styles"