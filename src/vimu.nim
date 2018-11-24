import lib/vimu/Core

#           01234567890123456789012345678901234
var line = " abcd fghi j klmno pqrst uvwxy zzz  "
let query = "d0d0d0d0d0d0d0d0d0d0d0d0"
var vimu = initVimu(query)
echo query
echo "01234567890123456789012345678901234"
echo "'", vimu.exec(line), "'"

