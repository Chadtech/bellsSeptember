_       = require 'lodash'
Nt      = require './noitech.coffee'
gen     = Nt.generate
eff     = Nt.effect
cp      = require 'child_process'
fs      = require 'fs'
say     = require './say.coffee'

{getFileName, removeFileExtension, getFileExtension} = 
  require './file-name-utilities.coffee'

lines   =  (require './init-lines.coffee')()
timings =  require './init-timings.coffee'
times   = (require './init-times.coffee') timings
voices  =  require './init-voices.coffee'

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

        lines = (require './' + fileName + '.coffee') fileName,
          voices
          lines
          times
          timings
          startingPoints
          voiceCount

        Nt.buildFile 'test.wav', 
          [ 
            Nt.convertTo64Bit lines[3]
            Nt.convertTo64Bit lines[2]
           ]
        cp.exec 'play test.wav'
        lines = (require './init-lines.coffee')()
        say 'Lines Reset'
