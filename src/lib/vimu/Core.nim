import nre, strutils
import Operation, EditLine, Move, Target, Delete

type Vimu* = ref object of RootObj
  operations: seq[Operation]

method exec*(this: Vimu, line: string): string {.base.} =
  var line = EditLine(line:line, cursor:0)
  for i in 0 .. this.operations.len-1:
    this.operations[i].apply(line)
    stderr.writeline(line.line, "(", line.cursor, ")") #debug
  return line.line

method parseQuery*(this: Vimu, query: string) {.base.} =
  var i = 0
  while i < query.len:
    #[ Parse number ]#
    var repeat1 = 1
    block:
      let m = query[i..query.len-1].match(re"[1-9]\d*")
      if m.isSome:
        repeat1 = parseInt($m.get)
        i += len($m.get)

    #[ Direct command ]#
    if $query[i] == "D":
      this.operations.add(Delete(target: Target(s: "$")))
      i += 1
      continue
    elif $query[i] == "x":
      for x in 1 .. repeat1:
        this.operations.add(Delete(target: Target(s: "l")))
      i += 1
      continue

    #[ Complexed command ]#
    var mode = 0
    if $query[i] == "d":
      mode = 1
      i += 1

    #[ Parse number ]#
    var repeat2 = 1
    block:
      let m = query[i..query.len-1].match(re"[1-9]\d*")
      if m.isSome:
        repeat2 = parseInt($m.get)
        i += len($m.get)

    #[ Parse target ]#
    var target: Target
    case $query[i]
    of "h", "l", "W", "B", "E", "0", "^", "$", "]":
      target = Target(s: $query[i])
    of "f", "t", "F", "T":
      if repeat1 == 1 or repeat2 == 1:
        target = Target(s:query[i..i+1])
        i += 1
      else:
        i += 2
        continue
    else:
      stderr.writeLine("[ERROR] Unsupported char: ", $query[i])
      quit(1)
    if mode == 0:
      for n in 1 .. repeat1*repeat2:
        this.operations.add(Move(target: target))
    elif mode == 1:
      for n in 1 .. repeat1*repeat2:
        this.operations.add(Delete(target: target))
    i += 1

proc initVimu*(query: string): Vimu =
  var this: Vimu = Vimu()
  this.operations = @[]
  this.parseQuery(query)
  return this

