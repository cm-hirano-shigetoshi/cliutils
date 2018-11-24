import Operation, EditLine, Move, Target, Delete

type Vimu* = ref object of RootObj
  operations: seq[Operation]
method exec*(this: Vimu, line: string): string {.base.} =
  var line = EditLine(line:line, cursor:0)
  for i in 0 .. this.operations.len-1:
    this.operations[i].apply(line)
    echo line.line, "(", line.cursor, ")"
  return line.line
method parseQuery*(this: Vimu, query: string) {.base.} =
  var i = 0
  while i < query.len:
    case $query[i]
    #[ 1 command ]#
    of "h", "l", "W", "B", "E", "0", "^", "$", "]":
      this.operations.add(Move(target:Target(s: $query[i])))
    of "x":
      this.operations.add(Delete(target:Target(s:"l")))
    i += 1
proc initVimu*(query: string): Vimu =
  var this: Vimu = Vimu()
  this.operations = @[]
  this.parseQuery(query)
  return this

