import strutils, nre

proc readAll*(file: string): seq[string] =
  let f = open(file, FileMode.fmRead)
  defer: f.close()
  return f.readAll().replace("\r","").replace(re"\n$","").split("\n")
proc readAllFromStdin*(): seq[string] =
  return stdin.readAll().replace("\r","").replace(re"\n$","").split("\n")
proc readAllFromFileOrStdin*(args: seq[string]): seq[string] =
  if args.len < 1 or args[0] == "-":
    return readAllFromStdin()
  else:
    return readAll(args[0])

proc readRawAll*(file: string): string =
  let f = open(file, FileMode.fmRead)
  defer: f.close()
  return f.readAll()
proc readRawAllFromStdin*(): string =
  return stdin.readAll()
proc readRawAllFromFileOrStdin*(args: seq[string]): string =
  if args.len < 1 or args[0] == "-":
    return readRawAllFromStdin()
  else:
    return readRawAll(args[0])

iterator readLines*(file: string): string =
  let f = open(file, FileMode.fmRead)
  defer: f.close()
  var line: string
  while f.readline(line):
    yield line.replace("\r","").replace(re"\n$","")
iterator readLinesFromStdin*(): string =
  var line: string
  while stdin.readline(line):
    yield line.replace("\r","").replace(re"\n$","")
iterator readLinesFromFileOrStdin*(args: seq[string]): string =
  if args.len < 1 or args[0] == "-":
    for line in readLinesFromStdin():
      yield line
  else:
    for line in readLines(args[0]):
      yield line

iterator readRawLines*(file: string): string =
  let f = open(file, FileMode.fmRead)
  defer: f.close()
  var line: string
  while f.readline(line):
    yield line.replace("\r","").replace(re"\n$","")
iterator readRawLinesFromStdin*(): string =
  var line: string
  while stdin.readline(line):
    yield line.replace("\r","").replace(re"\n$","")
iterator readRawLinesFromFileOrStdin*(args: seq[string]): string =
  if args.len < 1 or args[0] == "-":
    for line in readRawLinesFromStdin():
      yield line
  else:
    for line in readRawLines(args[0]):
      yield line

