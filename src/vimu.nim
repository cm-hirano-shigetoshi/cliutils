import lib/vimu/Core

#           01234567890123456789012345678901234
var line = "z abcd e fghi j klmno pqrst uvwxy zzz  "
let query = "$d5Tz"
var vimu = initVimu(query)
echo query
echo "'", line, "'"
echo " 01234567890123456789012345678901234567890123456789"
echo "'", vimu.exec(line), "'"


#01234567890123456789012345678901234
