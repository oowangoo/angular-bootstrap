fs = require('fs')
path = require('path')
module.exports = (grunt)->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
  grunt.initConfig(
    clean:
      tmp:['.tmp','docs/assets/']
    sass:
      bootstrap:
        files:[
          expand:true
          cwd:"src/stylesheet"
          src:['*.scss']
          dest:'.tmp/stylesheet'
          ext:'.css'
        ]
    coffee:
      bootstrap:
        files:[
          expand:true
          cwd:'./src/javascript'
          src:['**/*.coffee','!**/test/*.coffee','!**/docs/*.coffee']
          dest:'.tmp/javascript'
          ext:'.js'
        ]
      test:
        files:[
          epxand:true
          cwd:'src/javascript'
          src:['**/test/*.coffee']
          dest:".tmp/test"
          ext:'.js'
        ]
      demo:
        files:[
          expand:true
          cwd:"src/javascript"
          src:['**/docs/*.coffee']
          dest:".tmp/demo"
          ext:'.js'
        ]
    copy:
      docs:
        expand:true
        cwd:'src/javascript'
        src:['**/docs/*.*','!**/docs/*.coffee']
        dest:'.tmp/demo'
      javascript:
        expand:true
        cwd:'src/javascript'
        src:['**/*.js','!**/docs/*.js','!**/test/*.js']
        dest:'.tmp/javascript'
      test:
        expand:true
        cwd:'src/javascript'
        src:["**/test/*.js"]
        dest:'.tmp/test'
      server:
        expand:true
        cwd:'.tmp'
        src:['**/*.*']
        dest:'docs/assets'
    watch:
      options:
        livereload: true
      bootstrap_sass:
        files:'src/stylesheet/**/*.scss'
        tasks:['sass:bootstrap','copy:server']
      bootstrap_coffee:
        files:['src/javascript/**/*.coffee','!src/javascript/**/test/*.coffee','!src/javascript/**/docs/*.coffee']
        tasks:['coffee:bootstrap','copy:server']
      test_coffee:
        files:['src/javascript/**/test/*.coffee']
        tasks:['coffee:test','copy:server']
      demo_coffee:
        files:["src/javascript/**/docs/*.coffee"]
        tasks:['coffee:demo','copy:server']
      bootstrap_js:
        files:['src/javascript/**/*.js','!src/javascript/**/docs/*.js','!src/javascript/**/test/*.js']
        tasks:['copy:javascript','copy:server']
      test_js:
        files:["src/javascript/**/test/*.js"]
        tasks:['copy:test']
      docs:
        files:['src/javascript/**/docs/*.*','!src/javascript/**/docs/*.coffee']
        tasks:['copy:docs','copy:server']
    nodemon:
      docs:
        script:'app.js'
        options:
          watch:['app.js']
          cwd:'docs'
          env:
            DEV:true
            PORT: '3000'
            NODE_ENV: 'development'
    concurrent:
      docs:
        options:
          logConcurrentOutput: true
        tasks:['nodemon','watch']

  )

  writeModle = (moduleList)->
    filePath = './docs/views/index.ejs'
    index = fs.readFileSync(filePath,{encoding:'utf-8'})
    r = /<\!\-\-\s*begin\s*module\s*\-\->([\s|\w|<|\'|\"|\=|<|>|/|\/|\.]*)<\!\-\-\s*end\s*\-\->/
    scripts = []
    for module in moduleList
      scripts.push "<script type='text/javascript' src='/javascript/#{module}/#{module}.js'></script>"
    banner = "<!-- begin module -->\n\t#{scripts.join('\n\t')}\n\t<!-- end -->"
    index = index.replace(r,banner)
    fs.writeFileSync(filePath,index,{encoding:'utf-8'},)

  findModule = (base)->
    dirs = fs.readdirSync(base)
    module = []
    for d in dirs
      p = base + '/' + d
      stat = fs.statSync(p)
      if stat.isDirectory()
        name = path.basename(p)
        module.push name
    return module


  grunt.registerTask('ms','生成js引用',()->
    moduleList = findModule('src/javascript')
    writeModle(moduleList)
  )

  grunt.registerTask('s',[
    'clean'
    'sass:bootstrap'

    'coffee:bootstrap'
    'copy:javascript'

    'coffee:test'
    'copy:test'

    'coffee:demo'
    'copy:docs'

    'copy:server'

    'ms'

    'concurrent:docs'
  ])