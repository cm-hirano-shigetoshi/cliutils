import Operation, EditLine, Target

type Delete* = ref object of Operation

method apply*(this: Delete, line: EditLine) =
  let p = this.target.getForRange(line)
  if p >= 0:
    if p > line.cursor:
      line.line = line.line[0 .. line.cursor-1] & line.line[p .. line.line.len-1]
    elif p < line.cursor:
      line.line = line.line[0 .. p-1] & line.line[line.cursor .. line.line.len-1]
      line.cursor = p

