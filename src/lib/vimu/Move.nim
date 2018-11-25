import Operation, EditLine, Target

type Move* = ref object of Operation

method apply*(this: Move, line: EditLine) =
  let p = this.target.get(line)
  if p >= 0:
    line.cursor = this.target.get(line)

