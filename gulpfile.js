var gulp = require('gulp'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat'),
    elixir = require('laravel-elixir'),
    util = require('gulp-util').env,
    Task = elixir.Task;

elixir.extend('index',require('./gulp-tasks/index'));

elixir(function(mix){
  var page = util.page === undefined ? undefined : util.page.split(',');
  var build = page === undefined ? [
    'index'
  ] : page;
  for(var i=0;i<= build.length-1;i++){
      if(typeof mix[build[i]] == 'function'){
          mix[build[i]]();
      }
  }
});
