import strutils, sets, tables, parseopt, nre, algorithm
import ../lib/io

proc unique*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: line [OPTION]... [FILE]
    -b      : backward search.
    -f      : avoid comparing the first N fields."""
    echo s

  var args: seq[string] = @[]
  var forward = true
  var skipN = 0

  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        elif kind == cmdShortOption and key == "b":
          forward = false
        elif kind == cmdShortOption and key == "f":
          skipN = val.parseInt
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)

  proc skipFields(line: string): string =
    result = line
    for i in 1 .. skipN:
      result = result.replace(re"^\s*\S+\s+", "")

  var already = initSet[string]()
  if forward:
    for line in readLinesFromFileOrStdin(args):
      let compare = skipFields(line)
      if not already.contains(compare):
        echo line
        already.incl(compare)
  else:
    var out_lines: seq[string] = @[]
    for line in readAllFromFileOrStdin(args).reversed:
      let compare = skipFields(line)
      if not already.contains(compare):
        out_lines.add(line)
        already.incl(compare)
    for line in out_lines.reversed:
      echo line

