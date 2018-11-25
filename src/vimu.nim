import lib/vimu/Core

#           01234567890123456789012345678901234
var line = " abcd e fghi j klmno pqrst uvwxy zzz  "
let query = "9f "
var vimu = initVimu(query)
echo query
echo "'", line, "'"
echo " 01234567890123456789012345678901234"
echo "'", vimu.exec(line), "'"


#01234567890123456789012345678901234
