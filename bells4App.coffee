_       = require 'lodash'
Nt      = require './noitech.coffee'
gen     = Nt.generate
eff     = Nt.effect
cp      = require 'child_process'
fs      = require 'fs'
say     = require './say.coffee'

{getFileName, removeFileExtension, getFileExtension} = 
  require './file-name-utilities.coffee'

lines   = require './init-lines.coffee'
voices  = require './init-voices.coffee'
timings = require './init-timings.coffee'

filesToWatch = []

fs.readdir __dirname, (err, files) ->
  console.log files

  _.forEach files, (f) ->
    if (getFileExtension f) is '.csv'

      thisFile = {name: f}
      hash = fs.readFileSync __dirname + '/' + f

      fs.watch f, ->
        fileName = removeFileExtension f
        say fileName + ' CHANGED!'




