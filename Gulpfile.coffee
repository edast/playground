gulp = require 'gulp'

coffee = require 'gulp-coffee'
del = require 'del'
browserify = require 'browserify'
runSequence = require 'run-sequence'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'
jasmine = require 'gulp-jasmine'
coffeelint = require 'gulp-coffeelint'
_ = require 'underscore'

paths =
  scripts: ['coffee/**/*.coffee']
  specs: ['spec/**/*.coffee']
  build: 'build/js'

gulp.task 'clean', (cb) ->
  del ['build'], cb
  
COFFEE_DIR = "#{__dirname}/coffee/"

browserifyOpts = 
  derequire: false
  extensions: ['.coffee']
  paths: paths.scripts
  entries: "#{COFFEE_DIR}/app.coffee"
  commondir: false
  fullPaths: false
  debug: true
  insertGlobals: false
  detectGlobals: false

  
  
gulp.task 'scripts', ['clean', 'lint'], ->
  # Minify and copy all JavaScript (except vendor scripts)
  # with sourcemaps all the way down
  
  browserify browserifyOpts
    .plugin('minifyify', {output: "#{paths.build}/bundle.map"})
    .transform('coffeeify')
    .bundle()
    .pipe source 'script.min.js'
    .pipe gulp.dest paths.build

gulp.task 'watch', (cb) ->
  runSequence 'scripts', ->
  js = gulp.watch [paths.scripts, paths.specs], ['scripts']
  js.on 'change', changeReport

gulp.task 'test', ['scripts'], ->
  gulp.src paths.specs
  .pipe jasmine()
  
gulp.task 'lint', ->
  gulp.src _.flatten paths
    .pipe coffeelint()
    .pipe coffeelint.reporter()
          
changeReport = (event) ->
  console.log "  [#{event.type}] #{event.path}"
  runSequence 'test'

gulp.task 'default', ->
  runSequence 'scripts'
