import strutils, nre
import EditLine

type Target* = ref object of RootObj
  s*: string

method get*(this: Target, line: EditLine): int {.base.} =
  if this.s.len == 1:
    case this.s
    of "l":
      return min(line.cursor+1, line.line.len-1)
    of "h":
      return max(line.cursor-1, 0)
    of "0":
      return 0
    of "^":
      for m in line.line.findIter(re"\S"):
        return m.matchBounds.a
      return line.line.len-1
    of "$", "]":
      return line.line.len-1
    of "W":
      for m in line.line[line.cursor .. line.line.len-1].findIter(re"\s+"):
        return min(line.cursor + m.matchBounds.b + 1, line.line.len-1)
      return line.line.len-1
    of "B":
      var start = 0
      for m in line.line[0 .. line.cursor-1].findIter(re"\S+"):
        start = m.matchBounds.a
      return start
    of "E":
      for m in line.line[line.cursor+1 .. line.line.len-1].findIter(re"\S+"):
        return min(line.cursor+1 + m.matchBounds.b, line.line.len-1)
      return line.line.len-1
    else:
      return line.cursor
  elif this.s.len == 2:
    case $this.s[0]
    of "f":
      return max(line.cursor + line.line[line.cursor+1 .. line.line.len-1].find(this.s[1])+1, line.cursor)
    of "t":
      return max(line.cursor + line.line[line.cursor+1 .. line.line.len-1].find(this.s[1]), line.cursor)
    of "F":
      let p = line.line[0 .. line.cursor-1].rfind(this.s[1])
      if p < 0:
        return line.cursor
      else:
        return p
    of "T":
      let p = line.line[0 .. line.cursor-1].rfind(this.s[1])
      if p < 0:
        return line.cursor
      else:
        return p + 1

