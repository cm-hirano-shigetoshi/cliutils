import Action, EditingState

type RepeatAction* = ref object of Action
  action*: Action

method apply*(this: RepeatAction, edit: EditingState): int =
  if this.action != nil:
    if this.repeat >= 1:
      discard this.action.apply(edit, this.repeat)
    else:
      discard this.action.apply(edit)
  return 0

method setAction*(this: RepeatAction, action: Action) {.base.} =
  this.action = action
  if this.repeat < 1:
    this.repeat = action.repeat

