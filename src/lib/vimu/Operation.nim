import EditingState, Target

type Operation* = ref object of RootObj
  target*: Target
  repeat*: int

method apply*(this: Operation, edit: EditingState, n: int): int {.base.} = discard

method apply*(this: Operation, edit: EditingState): int {.base.} = discard

