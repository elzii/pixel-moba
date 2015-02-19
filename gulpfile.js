/*jslint indent:2, node:true, sloppy:true*/
var
  gulp = require('gulp'),
  coffee = require('gulp-coffee'),
  jade = require('gulp-jade'),
  plumber = require('gulp-plumber');

gulp.task('coffee', function () {
  return gulp.src('src/*.coffee')
    .pipe(plumber())
    .pipe(coffee())
    .pipe(gulp.dest('app'));
});

gulp.task('jade', function () {
  return gulp.src('src/*.jade')
    .pipe(plumber())
    .pipe(jade())
    .pipe(gulp.dest('app'));
});

gulp.task('watch', function () {
  gulp.watch('src/*.coffee', ['coffee']);
  gulp.watch('src/*.jade', ['jade']);
});

gulp.task('default', ['coffee', 'jade', 'watch']);
gulp.task('build', ['coffee', 'jade']);
