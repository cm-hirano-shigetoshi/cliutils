import strutils, parseopt, nre
import ../lib/io

proc count*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: count [OPTION]... QUERY [FILE]
    -n=<int>: show only lines have N of queries.
"""
    stdout.write s

  var args: seq[string] = @[]
  var filter = -1
  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        elif (kind == cmdShortOption and key == "n"):
           filter = val.parseInt
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)

  let query = args[0]; args.delete(0)
  var found_forN = false
  for line in readLinesFromFileOrStdin(args):
    var n = 0
    var p = 0
    while true:
      p = line.find(query, p)
      if p >= 0:
        n += 1
        p += query.len
      else:
        break
    if filter == -1:
      found_forN = true
      echo n
    elif n == filter:
      found_forN = true
      echo line
  if not found_forN:
    quit(1)
  else:
    quit(0)

