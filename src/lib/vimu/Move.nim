import Action, EditingState, Target

type Move* = ref object of Action

method apply*(this: Move, edit: EditingState, n: int): int =
  let p = this.target.get(edit, n)
  if p >= 0:
    edit.cursor = p
  return 0

method apply*(this: Move, edit: EditingState): int =
  return this.apply(edit, this.repeat)

