gulp = require "gulp"
sequence = require "gulp-sequence"

gulp.task "build", sequence "clean", "images", "template", "buildjs", "copy", "image-rev","styles", "views", "rev"