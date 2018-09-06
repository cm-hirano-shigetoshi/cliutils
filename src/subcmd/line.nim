import strutils, tables, parseopt, sets, nre
import ../lib/io, ../lib/range

proc line*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: line [OPTION]... PATTERN [FILE]
    -0      : index starts with 0.
    -v      : invert match.
    -B=<int>: also show before n lines.
    -A=<int>: also show after n lines.
    -C=<int>: also show before and after n+n lines."""
    echo s

  var args: seq[string] = @[]
  var zero = false
  var invert = false
  var before = 0
  var after = 0

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
        elif (kind == cmdShortOption and key == "v") or (kind == cmdLongOption and key == "invert"):
          invert = true
        elif (kind == cmdShortOption and key == "C") or (kind == cmdLongOption and key == "context"):
          if before == 0:
            before = val.parseInt
          if after == 0:
            after = val.parseInt
        elif (kind == cmdShortOption and key == "B") or (kind == cmdLongOption and key == "before"):
          before = val.parseInt
        elif (kind == cmdShortOption and key == "A") or (kind == cmdLongOption and key == "after"):
          after = val.parseInt
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)
    if args.len < 1:
      args.add(":")

  proc expandContext()
  proc print()

  let query = args[0]; args.delete(0)
  let lines = readAllFromFileOrStdin(args)
  var indices = getRange(query, lines.len, zero)
  print()


  proc expandContext() =
    var array: seq[int] = @[]
    for center in indices:
      for x in center-before .. center+after:
        array.add(x)
    indices = array

  proc print() =
    if not invert:
      if before > 0 or after > 0:
        expandContext()
      for i in indices:
        if i >= 0 and i < lines.len:
          echo lines[i]
    else:
      if before > 0 or after > 0:
        expandContext()
      var excludes = initSet[int]()
      for i in indices:
        excludes.incl(i)
      for i in 0 .. lines.len-1:
        if not excludes.contains(i):
          echo lines[i]

