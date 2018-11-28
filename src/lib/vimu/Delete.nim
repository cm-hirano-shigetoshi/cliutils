import Action, EditingState, Target

type Delete* = ref object of Action

method apply*(this: Delete, edit: EditingState, n: int): int =
  let p = this.target.getForRange(edit, n)
  if p >= 0:
    if p > edit.cursor:
      edit.text = edit.text[0 .. edit.cursor-1] & edit.text[p .. edit.text.len-1]
      if edit.text.len == 0:
        edit.cursor = 0
      elif edit.cursor >= edit.text.len:
        edit.cursor = edit.text.len-1
    elif p < edit.cursor:
      edit.text = edit.text[0 .. p-1] & edit.text[edit.cursor .. edit.text.len-1]
      edit.cursor = p
    return 1
  else:
    return -1

method apply*(this: Delete, edit: EditingState): int =
  return this.apply(edit, this.repeat)

