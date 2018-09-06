import strutils, nre

proc getMatrix*(lines: seq[string], delimiter: string, regex: bool): seq[seq[string]] =
  var data: seq[seq[string]] = @[]
  var maxColumnN = 0
  for r in 0 ..< lines.len:
    var row: seq[string]
    if regex:
      row = lines[r].split(re(delimiter))
    else:
      row = lines[r].split(delimiter)
    data.add(row)
    maxColumnN = max(maxColumnN, row.len)
  for r in 0 ..< lines.len:
    while data[r].len < maxColumnN:
      data[r].add("")
  return data

