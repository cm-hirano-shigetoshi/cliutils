import EditLine, Target

type Operation* = ref object of RootObj
  target*: Target

method apply*(this: Operation, line: EditLine) {.base.} = discard

