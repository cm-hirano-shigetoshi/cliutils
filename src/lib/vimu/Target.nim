import strutils, nre
import EditLine

type Target* = ref object of RootObj
  c*: string
  n*: int

method get*(this: Target, line: EditLine): int {.base.} =
  if this.c.len == 1:
    case this.c
    of "0":
      return 0
    of "^":
      for m in line.line.findIter(re"\S"):
        return m.matchBounds.a
      return line.line.len-1
    of "$", "]":
      return line.line.len-1
    of "l":
      return min(line.cursor+this.n, line.line.len-1)
    of "h":
      return max(line.cursor-this.n, 0)
    of "W":
      for n in 1 .. this.n:
        for m in line.line[line.cursor .. line.line.len-1].findIter(re"\c+"):
          return min(line.cursor + m.matchBounds.b + 1, line.line.len-1)
      return line.line.len-1
    of "B":
      var start = 0
      for n in 1 .. this.n:
        for m in line.line[0 .. line.cursor-1].findIter(re"\S+"):
          start = m.matchBounds.a
      return start
    of "E":
      for n in 1 .. this.n:
        for m in line.line[line.cursor+1 .. line.line.len-1].findIter(re"\S+"):
          return min(line.cursor+1 + m.matchBounds.b, line.line.len-1)
      return line.line.len-1
    else:
      return line.cursor
  elif this.c.len == 2:
    case $this.c[0]
    of "f":
      var p = line.cursor
      for n in 1 .. this.n:
        p = line.line.find($this.c[1], p+1)
        if p < 0:
          return -1
      return p
    of "t":
      var p = line.cursor
      for n in 1 .. this.n:
        p = line.line.find($this.c[1], p+1)
        if p < 0:
          return -1
      return p - 1
    of "F":
      var p = line.cursor
      for n in 1 .. this.n:
        p = line.line.rfind($this.c[1], p)
        if p < 0:
          return -1
      return p
    of "T":
      var p = line.cursor
      for n in 1 .. this.n:
        p = line.line.rfind($this.c[1], p)
        if p < 0:
          return -1
      return p + 1

method getForRange*(this: Target, line: EditLine): int {.base.} =
  if this.c.len == 1:
    case $this.c[0]
    of "E":
      return get(this, line) + 1
    else:
      let p = get(this, line)
      if p == 0:
        return p
      elif p == line.line.len-1:
        return p + 1
      else:
        return p
  elif this.c.len == 2:
    case $this.c[0]
    of "f", "t":
      let p = get(this, line)
      if p < 0:
        return -1
      else:
        return p + 1
    else:
      return get(this, line)
