import nre

type EditLine* = ref object of RootObj
  line*: string
  cursor*: int

type Target* = ref object of RootObj
  s: string
method get(this: Target, line: EditLine): int =
  case this.s
  of "l":
    return min(line.cursor+1, line.line.len-1)
  of "h":
    return max(line.cursor-1, 0)
  of "0":
    return 0
  of "^":
    for m in line.line.findIter(re"\S"):
      return m.matchBounds.a
    return line.line.len-1
  of "$", "]":
    return line.line.len-1
  else:
    return line.cursor
type Operation = ref object of RootObj
  repeat: int
method apply*(this: Operation, line: EditLine) =
  quit "to override!"

type Move* = ref object of Operation
  target: Target
method apply*(this: Move, line: EditLine) =
  line.cursor = this.target.get(line)

type Delete* = ref object of Operation
  target: Target
method apply*(this: Delete, line: EditLine) =
  let targetCursor = this.target.get(line)
  if targetCursor > line.cursor:
    line.line = line.line[0 .. line.cursor-1] & line.line[targetCursor .. line.line.len-1]

type Vimu* = ref object of RootObj
  operations: seq[Operation]
method exec*(this: Vimu, line: string): string =
  var line = EditLine(line:line, cursor:0)
  for i in 0 .. this.operations.len-1:
    this.operations[i].apply(line)
    echo line.line, "(", line.cursor, ")"
  return line.line
method parseQuery*(this: Vimu, query: string) =
  var i = 0
  while i < query.len:
    let q = query[i]
    case $q
    #[ 1 command ]#
    of "h", "l", "W", "B", "E", "0", "^", "$", "]":
      this.operations.add(Move(target:Target(s:($q))))
    of "x":
      this.operations.add(Delete(target:Target(s:"l")))
    i += 1
proc initVimu*(query: string): Vimu =
  var this: Vimu = Vimu()
  this.operations = @[]
  this.parseQuery(query)
  return this


var line = " abcd efghi  j klmno pqrst uvwxy z  "
let query = "$W0$^llhxxxx"
var vimu = initVimu(query)
echo vimu.exec(line)

