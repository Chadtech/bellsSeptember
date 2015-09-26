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
timings = require './init-timings.coffee'
voices  = require './init-voices.coffee'

fs.readdir __dirname, (err, files) ->
  console.log files

  _.forEach files, (f) ->
    if (getFileExtension f) is '.csv'

      fs.watch f, ->
        fileName = removeFileExtension f
        say fileName + ' CHANGED!'




