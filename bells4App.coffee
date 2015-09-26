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
times   = (require './init-times.coffee') timings
voices  = require './init-voices.coffee'

console.log times[0]
console.log timings[0]

voiceCount = 6

startingPoints =
  part0: 4
  part1: (16 * 4) + 4

fs.readdir __dirname, (err, files) ->

  say 'Ready'

  _.forEach files, (f) ->
    if (getFileExtension f) is '.csv'

      fs.watch f, ->
        fileName = removeFileExtension f
        say fileName + ' CHANGED!'

        # (require './' + fileName + '.coffee') fileName,
        #   voices
        #   lines
        #   timings
        #   startingPoints
