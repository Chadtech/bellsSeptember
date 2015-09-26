_   = require 'lodash'
Nt  = require './noitech.coffee'
gen = Nt.generate
eff = Nt.effect
say = require './say.coffee'

say 'Forming Lines'

lines = []
_.times 6, ->
  lines.push gen.silence sustain: 550000

module.exports = lines