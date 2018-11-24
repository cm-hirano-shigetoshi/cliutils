import lib/vimu/Core

#           01234567890123456789012345678901234
var line = " abcd fghi  j klmno pqrst uvwxy z  "
let query = "fjf t TaF f0t0T0F0tzf f f "
var vimu = initVimu(query)
echo query
echo "01234567890123456789012345678901234"
echo vimu.exec(line)

# abcd fghi  j klmno pqrst uvwxy z  
