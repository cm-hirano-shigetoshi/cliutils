import EditLine, Target

type Operation* = ref object of RootObj
  target*: Target
  repeat*: int

method apply*(this: Operation, line: EditLine, n: int) {.base.} = discard

method apply*(this: Operation, line: EditLine) {.base.} = discard

