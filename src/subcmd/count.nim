import strutils, parseopt, nre
import ../lib/io

proc count*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: count [OPTION]... QUERY [FILE]
"""
    stdout.write s

  var args: seq[string] = @[]
  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)

  let query = args[0]; args.delete(0)
  var found = false
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
    if n > 0:
      found = true
    echo n
  if found:
    quit(0)
  else:
    quit(1)

