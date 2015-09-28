fs      = require 'fs'
_       = require 'lodash'
Nt      = require './noitech.coffee'
gen     = Nt.generate
eff     = Nt.effect
cp      = require 'child_process'

rampRate = 60

module.exports = (f, voices, lines, times, timings, startingPoints, voiceCount) ->
  part = fs.readFileSync f + '.csv', 'utf8'

  part = _.map (part.split '\n'), (line) ->
    line.split ','

  startAt = startingPoints[ f ]

  _.times voiceCount, (vi) ->
    melody    = part[ vi ]
    timing    = timings[ vi ]
    time      = times[ vi ]
    voice     = voices[ vi ]
    line      = lines[ vi ]

    _.forEach melody, (note, ni) ->

      if note isnt ''

        thisTime = time[ ni + startAt ]
        nextTime = time[ ni + startAt + 1 ]

        if (vi % 2) is 0

          durationOfNote = sustain: (44100 * 4)
          blockOfSilence = gen.silence durationOfNote
          blockOfLine    = line.slice thisTime - rampRate, nextTime
          blockOfSilence = blockOfLine.concat blockOfSilence
          blockOfSilence = eff.fadeOut blockOfSilence, 
            (beginAt: 0, endAt: rampRate)

          line = Nt.displace blockOfSilence, line, thisTime - rampRate
          line = Nt.mix voice[ note ], line, thisTime

        else

          line = Nt.mix voice[ note ], line, thisTime

    lines[ vi ] = line

  lines


