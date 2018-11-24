import nre
import EditLine

type Target* = ref object of RootObj
  s*: string
method get*(this: Target, line: EditLine): int {.base.} =
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
  else:
    return line.cursor

