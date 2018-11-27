import Operation, EditLine, Target

type Action* = ref object of Operation

method apply*(this: Operation, line: EditLine, n: int) = discard

method apply*(this: Operation, line: EditLine) = discard

