gulp = require "gulp"
$ = require("gulp-load-plugins")({lazy: true})
run = require "run-sequence"
rimraf = require "rimraf"

config =
  srcFiles: ["src/flex_rows.styl"]
  dstDir: "dist/"

gulp.task "default", ["all"]

createStylusFiler = -> $.filter ["**/*.styl"], {restore: true}

gulp.task "all", (cb) ->
  run "build", "dist", -> cb()

createBuildPipe = ->
  stylusFilter = createStylusFiler()
  gulp.src config.srcFiles
  .pipe stylusFilter
  .pipe $.stylus()
  .pipe stylusFilter.restore

gulp.task "build", ->
  log "Compiling"
  createBuildPipe()
  .pipe gulp.dest(config.dstDir)

gulp.task "dist", ->
  log "Compiling and minifying"
  createBuildPipe()
  .pipe $.rename({suffix: ".min"})
  .pipe $.minifyCss()
  .pipe gulp.dest(config.dstDir)

gulp.task "clean", (cb) ->
  clean config.dstDir, cb

clean = (path, done) ->
  log "Cleaning: " + $.util.colors.blue(path)
  rimraf path, done

log = (msg) ->
  if typeof msg == "object"
    for item of msg
      if msg.hasOwnProperty item
        $.util.log $.util.colors.blue(msg[item])
  else
    $.util.log $.util.colors.blue(msg)

