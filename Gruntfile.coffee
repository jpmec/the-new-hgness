module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')


    path:
      dist: './web/dist/<%= pkg.name %>-<%= pkg.version %>/'


    clean:
      dist:
        src: ['<%= path.dist %>**']


    coffee:
      app:
        files: [
          expand: true,
          cwd: 'web/src/app/'
          dest: '<%= path.dist %>js'
          src: '*.coffee'
          ext: '.js'
        ]


    coffeelint:
      all: ['Gruntfile.coffee', 'web/src/app/*.coffee']


    copy:
      api:
        files: [
          dot: true
          expand: true
          cwd: 'web/src/api/0/'
          src: ['**']
          dest: '<%= path.dist %>api/0/'
        ,
          expand: true
          cwd: 'composer_modules/slim/slim/Slim/'
          src: ['**']
          dest: '<%= path.dist %>api/0/lib/Slim/'
        ]

      app:
        files: [
          expand: true
          cwd: 'bower_modules/angular/'
          src: ['angular.min.js']
          dest: '<%= path.dist %>/js/'
        ,
          expand: true
          cwd: 'bower_modules/angular-route/'
          src: ['angular-route.min.js']
          dest: '<%= path.dist %>/js/'
        ,
          expand: true
          cwd: 'bower_modules/angular-ui-bootstrap-bower/'
          src: ['ui-bootstrap-tpls.min.js']
          dest: '<%= path.dist %>/js/'
        ,
          expand: true
          cwd: 'bower_modules/bootstrap/dist/css/'
          src: ['bootstrap.min.css']
          dest: '<%= path.dist %>/css/'
        ,
          expand: true
          cwd: 'bower_modules/bootstrap/dist/fonts/'
          src: ['**']
          dest: '<%= path.dist %>/fonts/'
        ,
          expand: true
          cwd: 'bower_modules/bootstrap/dist/js/'
          src: ['bootstrap.min.js']
          dest: '<%= path.dist %>/js/'
        ,
          expand: true
          cwd: 'bower_modules/chartjs'
          src: ['Chart.min.js']
          dest: '<%= path.dist %>/js/'
        ,
          expand: true
          cwd: 'bower_modules/font-awesome/css/'
          src: ['font-awesome.min.css']
          dest: '<%= path.dist %>/css/'
        ,
          expand: true
          cwd: 'bower_modules/font-awesome/fonts/'
          src: ['**']
          dest: '<%= path.dist %>/fonts/'
        ,
          expand: true
          cwd: 'bower_modules/jquery/dist/'
          src: ['jquery.min.js']
          dest: '<%= path.dist %>/js/'
        ,
          expand: true
          cwd: 'bower_modules/lodash/dist'
          src: ['lodash.min.js']
          dest: '<%= path.dist %>/js/'
        ,
          expand: true
          cwd: 'bower_modules/momentjs/min'
          src: ['moment.min.js']
          dest: '<%= path.dist %>/js/'
        ,
          expand: true
          cwd: 'bower_modules/ng-grid'
          src: ['ng-grid.min.css']
          dest: '<%= path.dist %>/css/'
        ,
          expand: true
          cwd: 'bower_modules/ng-grid'
          src: ['ng-grid-2.0.7.min.js']
          dest: '<%= path.dist %>/js/'
        ]

      deploy:
        dot: true
        expand: true
        cwd: '<%= path.dist %>'
        src: ['**']
        dest: '/Library/WebServer/Documents/TheNewHgness/'


    html2js:
      app:
        options:
          base: 'web/src'
          module: 'appViews'

        src: [
          'web/src/app/*_view.html'
        ]
        dest: '<%= path.dist %>/js/app-views.js'

      angularHg:
        options:
          base: 'web/src/app'
          module: 'angularHgViews'

        src: [
          # 'web/src/app/angular-hg-status.html'
        ]
        dest: '<%= path.dist %>/js/angular-hg-views.js'


    htmlmin:
      dist:
        options:
          removeComments: true,
          collapseWhitespace: true

        files:
          '<%= path.dist %>index.html': '<%= path.dist %>index.html'


    jshint:
      all: ['*.json']

    less:
      all:
        options:
          paths:
            'bower_modules/bootstrap/less/'

        files:
          '<%= path.dist %>css/app.css': 'web/src/app/app.less'
          '<%= path.dist %>css/angular-hg.css': 'web/src/app/angular-hg.less'

    ngmin:
      all:
        src: ['<%= path.dist %>js/app.js']
        dest: '<%= path.dist %>js/app.js'

      angularHgViews:
        src: ['<%= path.dist %>js/angular-hg-views.js']
        dest: '<%= path.dist %>js/angular-hg-views.js'


    shell:
      phpIndex:
        options:
          stdout: true
          stderr: true
        command: 'php web/src/app/index.php > <%= path.dist %>index.html'


    watch:
      all:
        files: [
          'Gruntfile.coffee'
          'web/src/api/0/**'
          'web/src/app/**'
        ]

        tasks: [
          'coffeelint'
          'coffee'
          'jshint'
          'newer:copy:api'
          'newer:copy:app'
          'shell:phpIndex'
#          'htmlmin'
          'html2js'
          'ngmin'
          'less'
          'newer:copy:deploy'
        ]


    require('load-grunt-tasks')(grunt)


    grunt.registerTask 'deploy', [
      'copy:deploy'
    ]


    grunt.registerTask 'default', [
      'coffeelint'
      'coffee'
      'jshint'
      'copy:api'
      'copy:app'
      'shell:phpIndex'
#      'htmlmin'
      'html2js'
      'less'
      'ngmin'
    ]
