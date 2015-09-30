_   = require 'lodash'
Nt  = require './noitech.coffee'
gen = Nt.generate
eff = Nt.effect
say = require './say.coffee'

say 'Forming Lines'

returnLines = ->

  lines = []
  _.times 6, ->
    lines.push gen.silence sustain: 1400000

  lines

module.exports = returnLines