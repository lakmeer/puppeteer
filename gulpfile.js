
// Require

var gulp       = require('gulp'),
    gutil      = require('gulp-util'),
    browserify = require('browserify'),
    connect    = require('gulp-connect'),
    source     = require('vinyl-source-stream');


// Helpers

function reload (files) {
  gulp.src(files.path).pipe(connect.reload());
}

function prettyLog (label, text) {
  gutil.log( gutil.colors.bold("  " + label + " | ") + text );
}

function errorReporter (err){
  gutil.log( gutil.colors.red("Error: ") + gutil.colors.yellow(err.plugin) );
  if (err.message)    { prettyLog("message", err.message); }
  if (err.fileName)   { prettyLog("in file", err.fileName); }
  if (err.lineNumber) { prettyLog("on line", err.lineNumber); }
  return this.emit('end');
};


// Preconfigure bundlers

function compile (entry) {
  return browserify({
    debug: true,
    cache: {},
    packageCache: {},
    entries: [ entry ],
    extensions: '.ls'
  }).bundle()
}

function bundle (entry, filename) {
  return compile(entry)
    .on('error', errorReporter)
    .pipe(source(filename))
    .pipe(gulp.dest('public'));
}


// Tasks

gulp.task('server', function () {
  connect.server({
    root: 'public',
    livereload: true
  });
});

gulp.task('script', function () {
  return bundle('./src/index.ls', 'app.js');
});


// Register

gulp.task('default', [ 'server', 'script' ], function () {
  gulp.watch(['src/**/*.ls'], [ 'script' ]);
  gulp.watch(['public/**/*']).on('change', reload);
});

