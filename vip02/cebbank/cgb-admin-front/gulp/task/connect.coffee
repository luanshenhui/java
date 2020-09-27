gulp = require "gulp"
connect = require "gulp-connect"

gulp.task "connect",->
  connect.server
     root:"D:/projects/dhc-spirit/spirit-admin/build/views"
     livereload:true