import strutils, sets, tables, nre, algorithm
import ../lib/io, ../lib/getopts

proc unique*() =
  shift_arg()
  proc usage() =
    let s = """
  Usage: line [OPTION]... [FILE]
    -b      : backward search.
    -f      : avoid comparing the first N fields.
"""
    stdout.write s

  var args: seq[string] = @[]
  var forward = true
  var skipN = 0

  for kind, key, val in getopts():
    if kind == cmdArgument:
      args.add(key)
    elif kind == cmdShortOption and key == "b":
      forward = false
    elif kind == cmdShortOption and key == "f":
      skipN = val.parseInt
    else:
      usage()
      quit(0)

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

