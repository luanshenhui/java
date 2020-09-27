gulp = require "gulp"
deletefile = require('gulp-delete-file');

gulp.task "delete", ->
  gulp.src "build/**/*.*"
  .pipe deletefile({
    deleteMatch: true
  })

