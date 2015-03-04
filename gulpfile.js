/*jslint indent:2, node:true, sloppy:true*/
var
  gulp = require('gulp'),
  coffee = require('gulp-coffee'),
  jade = require('gulp-jade'),
  sass = require('gulp-sass'),
  plumber = require('gulp-plumber');

gulp.task('coffee', function () {
  return gulp.src('src/**/*.coffee')
    .pipe(plumber())
    .pipe(coffee())
    .pipe(gulp.dest('app'));
});

gulp.task('sass', function () {
  return gulp.src('src/**/*.scss')
    .pipe(plumber())
    .pipe(sass())
    .pipe(gulp.dest('app'));
});

gulp.task('jade', function () {
  return gulp.src('src/*.jade')
    .pipe(plumber())
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest('app'));
});

gulp.task('maps', function () {
  return gulp.src('src/maps/**')
    .pipe(plumber())
    .pipe(gulp.dest('app/maps'));
});

gulp.task('heroes', function () {
  return gulp.src('src/heroes/**')
    .pipe(plumber())
    .pipe(gulp.dest('app/heroes'));
});

gulp.task('watch', function () {
  gulp.watch('src/**/*.coffee', ['coffee']);
  gulp.watch('src/**/*.scss', ['sass']);
  gulp.watch('src/*.jade', ['jade']);
  gulp.watch('src/maps/**', ['maps']);
  gulp.watch('src/heroes/**', ['heroes']);
});

gulp.task('default', ['coffee', 'jade', 'sass', 'maps', 'heroes', 'watch']);
gulp.task('build', ['coffee', 'jade', 'sass', 'maps', 'heroes']);
