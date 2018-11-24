import Operation, Target, EditLine

type Move* = ref object of Operation
  target*: Target
method apply*(this: Move, line: EditLine) =
  line.cursor = this.target.get(line)

