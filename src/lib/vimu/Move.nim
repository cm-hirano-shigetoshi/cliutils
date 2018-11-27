import Action, EditLine, Target

type Move* = ref object of Action

method apply*(this: Move, line: EditLine, n: int) =
  let p = this.target.get(line, n)
  if p >= 0:
    line.cursor = p

method apply*(this: Move, line: EditLine) =
  this.apply(line, this.repeat)

