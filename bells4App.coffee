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
sys      = require 'util'
stdin    = process.openStdin()


{getFileName, removeFileExtension, getFileExtension} = 
  require './file-name-utilities.coffee'


lines       = (require './init-lines.coffee')()
timings     = (require './init-timings.coffee') null
timingsSeed = timings.seed
timings     = timings.timings
times       = (require './init-times.coffee') timings
voices      =  require './init-voices.coffee'

seed       = 'affordableD.wav'
justPlayed = ''

voiceCount = 6

startingPoints =
  part0: 4
  part1: 4 + 128
  part2: 4 + 128 + 96

buildProcess = (fileName) => 

  say 'Compiling ' + fileName

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
  Convolve fileName + '.wav', seed


fs.readdir __dirname, (err, files) ->

  say 'Ready'

  _.forEach files, (f) ->
    if (getFileExtension f) is '.csv'

      fs.watch f, ->

        fileName = removeFileExtension f
        say fileName + ' changed'

        buildProcess fileName

        say 'Playing ' + fileName
        play fileName + '_CONVOLVEDw' + seed
        justPlayed = fileName + '_CONVOLVEDw' + seed

        lines = (require './init-lines.coffee')()
        say 'Lines Reset'



console.log 'Bells 4 App Terminal :'
stdin.addListener 'data', (d) ->
  d = d.toString().trim()
  d = d.split ' '

  switch d[0]

    when 'play'
      say 'Playing ' + d[1]
      switch d[1]
        when 'prior'
          play justPlayed
        
        else
          f = './' + d[1] + '.wav'
          if fs.existsSync f
            play './' + d[1] + '.wav'
          else
            say 'File does not exist'

    when 'save'
      switch d[1]
        when 'timings'
          fs.writeFileSync __dirname + '/timings', 
            _.reduce timingsSeed, (sum, timing) -> sum + '\n' + timing 
          say 'Timings Saved'

        when 'placements'
          timeSeed   = ((require './init-times.coffee') [ timingsSeed ])[0]
          timeSeed.slice 0, 10
          
          placements = _.map (_.keys startingPoints), (key, ki) ->
            point = startingPoints[ key ]
            ts    = timeSeed[ point + 4 ] // 1
            ts + ' - ( 88200 * ' + ki + ') = ' + (ts - (88200 * ki)) + '\n'

          placements = _.reduce placements, (sum, item) -> sum + item
          fs.writeFileSync __dirname + '/placements', placements
          say 'placements saved'

    when 'build'

      if d.length is 1

        fs.readdir __dirname, (err, files) ->

          say 'Building all'

          _.forEach files, (f) ->
            if (getFileExtension f) is '.csv'

              fileName = removeFileExtension f
              buildProcess fileName

              lines = (require './init-lines.coffee')()
              say 'Lines Reset'

          say 'Finished Building All'

      else
        d.shift()

        _.forEach d, (f) ->

          say 'Building ' + f
          buildProcess f

          lines = (require './init-lines.coffee')()
          say 'Lines Reset'


    when 'load'
      switch d[1]
        when 'timings'      
          tSeed = (fs.readFileSync __dirname + '/timings', 'utf8').split '\n'
          tSeed = _.map tSeed, (t) ->
            parseFloat t
          timings     = (require './init-timings.coffee') tSeed
          timingsSeed = timings.seed
          timings     = timings.timings
          times       = (require './init-times.coffee') timings

          say 'Timings Loaded'

    when 'new'
      switch d[1]
        when 'timings'      

          timings     = (require './init-timings.coffee') null
          timingsSeed = timings.seed
          timings     = timings.timings
          times       = (require './init-times.coffee') timings

          say 'Timings Loaded'

    else
      say 'Does not compute'












