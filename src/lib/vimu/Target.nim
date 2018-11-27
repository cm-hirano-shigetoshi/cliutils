import strutils, nre
import EditingState

type Target* = ref object of RootObj
  c*: string

method get*(this: Target, edit: EditingState, n: int): int {.base.} =
  if this.c.len == 1:
    case this.c
    of "0":
      return 0
    of "^":
      for m in edit.text.findIter(re"\S"):
        return m.matchBounds.a
      return edit.text.len-1
    of "$", "]":
      return edit.text.len-1
    of "l":
      return min(edit.cursor+n, edit.text.len-1)
    of "h":
      return max(edit.cursor-n, 0)
    of "W":
      var i = 0
      for m in edit.text[edit.cursor .. edit.text.len-1].findIter(re"\s+"):
        i += 1
        if i >= n:
          return min(edit.cursor + m.matchBounds.b + 1, edit.text.len-1)
      return edit.text.len-1
    of "B":
      var starts: seq[int] = @[]
      for m in edit.text[0 .. edit.cursor-1].findIter(re"\S+"):
        starts.add(m.matchBounds.a)
      if starts.len == 0:
        return 0
      else:
        return starts[starts.len - n]
    of "E":
      var i = 0
      for m in edit.text[edit.cursor+1 .. edit.text.len-1].findIter(re"\S+"):
        i += 1
        if i >= n:
          return min(edit.cursor+1 + m.matchBounds.b, edit.text.len-1)
      return edit.text.len-1
    else:
      return edit.cursor
  elif this.c.len == 2:
    case $this.c[0]
    of "f":
      var p = edit.cursor
      for n in 1 .. n:
        p = edit.text.find($this.c[1], p+1)
        if p < 0:
          return -1
      return p
    of "t":
      var p = edit.cursor
      for n in 1 .. n:
        p = edit.text.find($this.c[1], p+1)
        if p < 0:
          return -1
      return p - 1
    of "F":
      var p = edit.cursor
      for n in 1 .. n:
        p = edit.text.rfind($this.c[1], p)
        if p < 0:
          return -1
      return p
    of "T":
      var p = edit.cursor
      for n in 1 .. n:
        p = edit.text.rfind($this.c[1], p)
        if p < 0:
          return -1
      return p + 1

method getForRange*(this: Target, edit: EditingState, n: int): int {.base.} =
  if this.c.len == 1:
    case $this.c[0]
    of "E":
      return get(this, edit, n) + 1
    else:
      let p = get(this, edit, n)
      if p == 0:
        return p
      elif p == edit.text.len-1:
        return p + 1
      else:
        return p
  elif this.c.len == 2:
    case $this.c[0]
    of "f", "t":
      let p = get(this, edit, n)
      if p < 0:
        return -1
      else:
        return p + 1
    else:
      return get(this, edit, n)
