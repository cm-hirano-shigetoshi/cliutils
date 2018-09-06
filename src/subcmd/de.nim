import strutils, parseopt, nre
import ../lib/io

proc de*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: de [OPTION]... PATTERN [FILE]
    -n      : repeat N times."""
    echo s

  var repeatN = 1

  var args: seq[string] = @[]
  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        elif (kind == cmdShortOption and key == "n"):
          repeatN = val.parseInt
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)

  if repeatN >= 0:
    for line in readLinesFromFileOrStdin(args):
      var l = line
      for i in 1 .. repeatN:
        l = l.replace(re"^\s*\S+\s*", "")
      l = l.replace(re"^\s+","").replace(re"\s+$","")
      echo l
  else:
    for line in readLinesFromFileOrStdin(args):
      var l = line
      for i in 1 .. -repeatN:
        l = l.replace(re"\s*\S+\s*$", "")
      l = l.replace(re"^\s+","").replace(re"\s+$","")
      echo l

