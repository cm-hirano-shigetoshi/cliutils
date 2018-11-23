import strutils, tables, parseopt, nre, sets
import ../lib/table, ../lib/io, ../lib/range

proc island*(tmpArgs: openArray[string]) =
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

  var minusEvacuatedArgs: seq[string] = @[]
  for a in tmpArgs:
    if a != "-0" and a.match(re"^-[0-9]") != none(RegexMatch):
      minusEvacuatedArgs.add("" & a)
    else:
      minusEvacuatedArgs.add(a)

  if minusEvacuatedArgs.len > 0:
    try:
      var p = initOptParser(minusEvacuatedArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          if key.match(re"^-[0-9]") != none(RegexMatch):
            args.add(key[1..key.len-1])
          else:
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
    except:
      usage()
      quit(1)

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
