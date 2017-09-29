var gulp = require('gulp'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat'),
    elixir = require('laravel-elixir'),
    gutil = require('gulp-util'),
    cjsx = require('gulp-cjsx'),
    Task = elixir.Task;

var sources = {
  input: {
    js: [
      'assets/javascripts/jquery-2.1.0.js',
      // 'assets/javascripts/react/react.js',
      // 'assets/javascripts/react/react-dom.js',
      'node_modules/react/dist/react.js',
      'node_modules/react-dom/dist/react-dom.js',
      'node_modules/react-bootstrap/dist/react-bootstrap.js',
      'node_modules/styled-components/dist/styled-components.js',
      // 'node_modules/mathjs/dist/math.js',
      // 'assets/javascripts/flux/flux.js',
      'node_modules/flux/dist/Flux.js',
      'assets/javascripts/flux/init-dispatcher.js',
      'assets/javascripts/flux/fbemitter.js',
      'assets/javascripts/lodash.js',
      'assets/javascripts/application.js',
      'assets/javascripts/chart/highcharts.js',
      'assets/javascripts/chart/exporting.js',
    ],
    cjsx: [
      'assets/javascripts/react-store/key-generator.cjsx',
      'assets/javascripts/react-store/global-store.cjsx',
      'assets/javascripts/components/index.cjsx',
    ]
  },
  output: {
    js: {
      path: 'public/js',
      file: 'index.js',
    },
  }
};

module.exports = function() {
	new Task('scripts index', function() {
		var srcFile =  sources.input.js;
    console.log(srcFile);
    return gulp.src(sources.input.cjsx)
               .pipe(cjsx({bare: true}).on('error',function(error){
                 console.log(error);
                 this.emit('end')
               }))
               .pipe(concat('coffee-index.js'))
               .pipe(gulp.dest(sources.output.js.path))
               .on('end',function(){
                 var coffeeIndex = [sources.output.js.path+"/coffee-index.js"];
                 var jsIndex = sources.input.js.concat(coffeeIndex);
                 gulp.src(jsIndex)
                     .pipe(gutil.env.production ? uglify() : gutil.noop())
                     .pipe(concat(sources.output.js.file))
                     .pipe(gulp.dest(sources.output.js.path))
                     .on('end', function(message) { console.info( message ) })
               });
	}).watch(sources.input.js.concat(sources.input.cjsx));
}
