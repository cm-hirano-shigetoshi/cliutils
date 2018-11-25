import nre, strutils
import Operation, EditLine, Move, Target, Delete

type Vimu* = ref object of RootObj
  operations: seq[Operation]

method exec*(this: Vimu, line: string): string {.base.} =
  var line = EditLine(line:line, cursor:0)
  for i in 0 .. this.operations.len-1:
    this.operations[i].apply(line)
    #stderr.writeline(line.line, "(", line.cursor, ")") #debug
  return line.line

method parseQuery*(this: Vimu, query: string) {.base.} =
  var i = 0
  while i < query.len:
    #[ Parse number ]#
    var repeat1 = -1
    block:
      let m = query[i..query.len-1].match(re"[1-9]\d*")
      if m.isSome:
        repeat1 = parseInt($m.get)
        i += len($m.get)

    #[ Dot command ]#
    #[
    if $query[i] == ".":
      if prevAction != nil:
        if repeat1 < 0:
          for x in 1 .. prevActionN:
            this.operations.add(prevAction)
        else:
          for x in 1 .. repeat1:
            this.operations.add(prevAction)
      i += 1
      continue
    ]#

    if repeat1 == -1:
      repeat1 = 1

    #[ Direct command ]#
    if $query[i] == "D":
      this.operations.add(Delete(target: Target(c: "$")))
      i += 1
      continue
    elif $query[i] == "x":
      this.operations.add(Delete(target: Target(c: "l", n: repeat1)))
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

    let repeat = repeat1 * repeat2

    #[ Parse target ]#
    var target: Target
    case $query[i]
    of "0", "^", "$", "]":
      target = Target(c: $query[i])
    of "h", "l", "W", "B", "E":
      target = Target(c: $query[i], n: repeat)
    of "f", "t", "F", "T":
      target = Target(c: query[i..i+1], n: repeat)
      i += 1
    else:
      stderr.writeLine("[ERROR] Unsupported char: ", $query[i])
      quit(1)
    if mode == 0:
      let move = Move(target: target)
      this.operations.add(move)
    elif mode == 1:
      let action = Delete(target: target)
      this.operations.add(action)
    i += 1

proc initVimu*(query: string): Vimu =
  var this: Vimu = Vimu()
  this.operations = @[]
  this.parseQuery(query)
  return this

