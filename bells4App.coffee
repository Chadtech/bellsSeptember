_        = require 'lodash'
Nt       = require './noitech.coffee'
gen      = Nt.generate
eff      = Nt.effect
cp       = require 'child_process'
fs       = require 'fs'
say      = require './say.coffee'
play     = require './play.coffee'
Mixer    = require './channel-mixer.coffee'
Convolve = require './convolve.coffee'



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

        Channels = (require './init-channels.coffee')(lines[0].length)

        Channels = Mixer Channels, lines[0], [ 0.9 , 0.2 ], [ 0, 0.025 ]
        Channels = Mixer Channels, lines[1], [ 0.5, 0.65 ], [ 0.01, 0  ]
        Channels = Mixer Channels, lines[2], [ 0.7, 0.3  ], [ 0, 0.15  ]
        Channels = Mixer Channels, lines[3], [ 0.3, 0.7  ], [ 0.15, 0  ]
        Channels = Mixer Channels, lines[4], [ 0.2,  0.9 ], [ 0.025, 0 ]
        Channels = Mixer Channels, lines[5], [ 0.65, 0.5 ], [ 0, 0.01  ]

        Channels = _.map Channels, (channel) ->
          Nt.convertTo64Bit channel

        say 'Building ' + fileName
        Nt.buildFile fileName + '.wav', Channels
        
        say 'Convolving ' + fileName
        Convolve fileName + '.wav', 'cheapoC.wav'

        say 'Playing ' + fileName
        play fileName + '_CONVOLVEDwcheapoC.wav'

        lines = (require './init-lines.coffee')()
        say 'Lines Reset'







