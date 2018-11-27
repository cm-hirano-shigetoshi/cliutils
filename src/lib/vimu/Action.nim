import Operation, EditingState, Target

type Action* = ref object of Operation

method apply*(this: Operation, edit: EditingState, n: int) = discard

method apply*(this: Operation, edit: EditingState) = discard

