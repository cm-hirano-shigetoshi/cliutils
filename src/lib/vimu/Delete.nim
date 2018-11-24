import Operation, EditLine, Target

type Delete* = ref object of Operation
  target*: Target
method apply*(this: Delete, line: EditLine) =
  let targetCursor = this.target.get(line)
  if targetCursor > line.cursor:
    line.line = line.line[0 .. line.cursor-1] & line.line[targetCursor .. line.line.len-1]

