import EditLine

type Operation* = ref object of RootObj
  repeat: int
method apply*(this: Operation, line: EditLine) {.base.} =
  quit "to override!"

