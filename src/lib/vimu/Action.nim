import Operation, EditingState, Target

type Action* = ref object of Operation

method apply*(this: Action, edit: EditingState, n: int): int = discard

method apply*(this: Action, edit: EditingState): int = discard

