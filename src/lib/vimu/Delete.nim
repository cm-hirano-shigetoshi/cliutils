import Action, EditingState, Target

type Delete* = ref object of Action

method apply*(this: Delete, edit: EditingState, n: int) =
  let p = this.target.getForRange(edit, n)
  if p >= 0:
    if p > edit.cursor:
      edit.text = edit.text[0 .. edit.cursor-1] & edit.text[p .. edit.text.len-1]
    elif p < edit.cursor:
      edit.text = edit.text[0 .. p-1] & edit.text[edit.cursor .. edit.text.len-1]
      edit.cursor = p

method apply*(this: Delete, edit: EditingState) =
  this.apply(edit, this.repeat)

