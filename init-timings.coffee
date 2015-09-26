_   = require 'lodash'
Nt  = require './noitech.coffee'
gen = Nt.generate
eff = Nt.effect
say = require './say.coffee'

say 'Making timings'

beatDuration  = 7600
timings       = [ 0 ]
_.times (64 * 8), (time) =>
  nextTime      =  Math.random() / 40
  nextTime      += 0.9845
  nextTime      *= beatDuration
  beatDuration  =  nextTime // 1

  timings.push (timings[ time ] + beatDuration )
allTimings = []
_.times 6, ->
  anotherTiming = _.map timings, (timing) ->
    (timing + (Math.random() * 3000) - 1500) // 1
  allTimings.push anotherTiming


module.exports = allTimings