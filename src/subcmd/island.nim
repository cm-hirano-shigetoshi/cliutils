import strutils, tables, nre, sets
import ../lib/table, ../lib/io, ../lib/range, ../lib/getopts

proc island*() =
  shift_arg()
  proc usage() =
    let s = """
  Usage: island [OPTION]... PATTERN [FILE]
    -0      : index starts with 0.
    -j=<str>: string with which join.
    -v      : inverse.
"""
    stdout.write s

  var args: seq[string] = @[]
  var zero = false
  var join = "\t"
  var inverse = false

  for kind, key, val in getopts():
    if kind == cmdArgument:
      args.add(key)
    elif kind == cmdShortOption and key == "0":
      zero = true
    elif kind == cmdShortOption and key == "j":
      join = val
    elif kind == cmdShortOption and key == "v":
      inverse = true
    else:
      usage()
      quit(0)

  if args.len < 1:
    args.add(":")

  let query = args[0]; args.delete(0)

  proc getLine(line: string): string =
    if not inverse:
      let matches = line.findAll(re"\S+")
      var s = ""
      for i in getRange(query, matches.len, zero):
        if s.len > 0:
          s &= join
        s &= matches[i]
      return s
    else:
      let matches = line.findAll(re"\S+")
      var exclude = initSet[int]()
      for i in getRange(query, matches.len, zero):
        exclude.incl(i)
      var s =""
      for i in 0 .. matches.len-1:
        if not exclude.contains(i):
          if s.len > 0:
            s &= join
          s &= matches[i]
      return s

  for line in readLinesFromFileOrStdin(args):
    echo getLine(line)
