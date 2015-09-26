Nt  = require './noitech.coffee'
gen = Nt.generate
eff = Nt.effect
say = require './say.coffee'


octavesOfBellB = []
thisOctave     = []

say 'Loading Bells'

for bellIndex in [0 .. 44 ]

  bellNumber = bellIndex % 5
  bellNumber += ''
  bellNumber = (bellIndex // 5) + bellNumber

  filePath = './bellB/bellB' + bellNumber
  filePath += '.wav'

  thisBellSound = Nt.open filePath
  thisBellSound = Nt.convertToFloat thisBellSound[0]
  thisBellSound = eff.vol thisBellSound, factor: 0.3
  
  thisOctave.push thisBellSound

  if (bellIndex % 5) is 4
    octavesOfBellB.push thisOctave

    thisOctave = []

say 'Assigning Voices'

voice0 =
  '14': octavesOfBellB[2][4]
  '20': octavesOfBellB[3][0]
  '21': octavesOfBellB[3][1]
  '22': octavesOfBellB[3][2]

voice1 =
  '14': octavesOfBellB[2][4]
  '20': octavesOfBellB[3][0]
  '21': octavesOfBellB[3][1]
  '22': octavesOfBellB[3][2]

voice2 = 
  '24': octavesOfBellB[3][4]
  '30': octavesOfBellB[4][0]
  '31': octavesOfBellB[4][1]
  '32': octavesOfBellB[4][2]
  '33': octavesOfBellB[4][3]
  '34': octavesOfBellB[4][4]
  '40': octavesOfBellB[5][0]

voice3 = 
  '24': octavesOfBellB[3][4]
  '30': octavesOfBellB[4][0]
  '31': octavesOfBellB[4][1]
  '32': octavesOfBellB[4][2]
  '33': octavesOfBellB[4][3]
  '34': octavesOfBellB[4][4]
  '40': octavesOfBellB[5][0]

voice4 = 
  '42': octavesOfBellB[5][2]
  '43': octavesOfBellB[5][3]
  '44': octavesOfBellB[5][4]
  '50': octavesOfBellB[6][0]

voice5 = 
  '42': octavesOfBellB[5][2]
  '43': octavesOfBellB[5][3]
  '44': octavesOfBellB[5][4]
  '50': octavesOfBellB[6][0]

voices =
  0: voice0
  1: voice1
  2: voice2
  3: voice3
  4: voice4
  5: voice5

module.exports = voices