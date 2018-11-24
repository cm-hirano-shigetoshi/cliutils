import Operation, EditLine, Move, Target, Delete

type Vimu* = ref object of RootObj
  operations: seq[Operation]
method exec*(this: Vimu, line: string): string {.base.} =
  var line = EditLine(line:line, cursor:0)
  for i in 0 .. this.operations.len-1:
    this.operations[i].apply(line)
    stderr.writeline(line.line, "(", line.cursor, ")")
  return line.line
method parseQuery*(this: Vimu, query: string) {.base.} =
  var i = 0
  while i < query.len:
    #[ Direct command ]#
    if $query[i] == "x":
      this.operations.add(Delete(target: Target(s: "l")))
      i += 1
      continue
    if $query[i] == "D":
      this.operations.add(Delete(target: Target(s: "$")))
      i += 1
      continue

    #[ Complexed command ]#
    var mode = 0
    if $query[i] == "d":
      mode = 1
      i += 1
    var target: Target
    case $query[i]
    of "h", "l", "W", "B", "E", "0", "^", "$", "]":
      target = Target(s: $query[i])
    of "f", "t", "F", "T":
      target = Target(s:query[i..i+1])
      i += 1
    else:
      stderr.writeLine("[ERROR] Unsupported char: ", $query[i])
      quit(1)
    if mode == 0:
      this.operations.add(Move(target: target))
    elif mode == 1:
      this.operations.add(Delete(target: target))
    i += 1
proc initVimu*(query: string): Vimu =
  var this: Vimu = Vimu()
  this.operations = @[]
  this.parseQuery(query)
  return this

