'use strict';
module.exports = function (grunt) {

  var buildPath = './bin-release/build';
  var uploadPath = './html/flash/2013/';

  grunt.initConfig({
    'ftp-deploy': {
      build: {
        auth: {
          host: 'anothercupdevelopment.org',
          port: 21,
          authKey: 'key1',
          authPath: 'ftp_auth'
        },
        src: buildPath,
        dest: uploadPath,
        exclusions: [buildPath + '/**/.DS_Store',
                      buildPath + '/com',
                      buildPath + '/org',
                      buildPath + '/nyc_cup_housing.html']
      }
    },

    clean: {
      build: ['bin-release/build']
    },

    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: buildPath,
          dest: buildPath+'/',
          src: [
            'nyc_cup_housing.html'
          ],
          rename: function(dest, src) {
            return dest + src.replace('nyc_cup_housing','index');
          }
        }]
      }
    }
  });

  grunt.loadTasks('tasks');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');

  grunt.registerTask('upload', [
    'copy',
    'ftp-deploy',
  ]);
};
