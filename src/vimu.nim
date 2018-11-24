import lib/vimu/Core

var line = " abcd efghi  j klmno pqrst uvwxy z  "
let query = "$W0$^llhxxxx"
var vimu = initVimu(query)
echo vimu.exec(line)

