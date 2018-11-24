import Operation, Target, EditLine

type Move* = ref object of Operation
  target*: Target
method apply*(this: Move, line: EditLine) =
  let p = this.target.get(line)
  if p >= 0:
    line.cursor = this.target.get(line)

