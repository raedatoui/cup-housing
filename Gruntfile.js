'use strict';
module.exports = function (grunt) {

  var buildPath = './bin-release/build';
  var uploadPath = './html/flash/2013/';
  var dataPath = './assets/data/';

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
      },
      data: {
        auth: {
          host: 'anothercupdevelopment.org',
          port: 21,
          authKey: 'key1',
          authPath: 'ftp_auth'
        },
        src: dataPath,
        dest: uploadPath + 'data',
        exclusions: [dataPath + '/**/.DS_Store']
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
    },

    watch: {
      scripts: {
        files: [dataPath+'/*'],
        tasks: ['ftp-deploy:data'],
        options: {
          spawn: false,
        },
      },
    }

  });

  grunt.loadTasks('tasks');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('build', ['copy', 'ftp-deploy:build']);
  grunt.registerTask('data', ['ftp-deploy:data']);
};
