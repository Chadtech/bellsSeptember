_   = require 'lodash'
Nt  = require './noitech.coffee'
gen = Nt.generate
eff = Nt.effect
say = require './say.coffee'

module.exports = (seed) ->

  say 'Making timings'

  timings = undefined
  if seed is null
    beatDuration    = 7600
    timings         = [ 0 ]
    _.times (64 * 8),  =>
      randomness = Math.random() / 40
      time          =  randomness
      time         +=  1 - (1 / 80)
      time         *= beatDuration
      beatDuration  =  time // 1
      timings.push time 
  else
    timings = seed

  alltimings = []

  _.times 6, ->
    anotherTime = _.map timings, (time) ->
      (time + (Math.random() * 200) - 100) // 1
    alltimings.push anotherTime

  output =
    seed:    _.map timings, (t) -> t // 1
    timings: alltimings

  output