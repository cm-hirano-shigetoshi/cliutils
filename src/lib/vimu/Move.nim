import Action, EditingState, Target

type Move* = ref object of Action

method apply*(this: Move, edit: EditingState, n: int) =
  let p = this.target.get(edit, n)
  if p >= 0:
    edit.cursor = p

method apply*(this: Move, edit: EditingState) =
  this.apply(edit, this.repeat)

