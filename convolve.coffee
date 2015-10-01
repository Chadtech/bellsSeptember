cp = require 'child_process'

module.exports = (what, seed) ->
  cmd = './convolve '
  cmd += what + ' ' + seed + ' 0.25'
  cp.execSync cmd