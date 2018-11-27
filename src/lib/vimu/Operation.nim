import EditingState, Target

type Operation* = ref object of RootObj
  target*: Target
  repeat*: int

method apply*(this: Operation, edit: EditingState, n: int) {.base.} = discard

method apply*(this: Operation, edit: EditingState) {.base.} = discard

