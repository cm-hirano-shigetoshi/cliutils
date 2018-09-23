import strutils, parseopt, nre, tables, algorithm
import ../lib/io

proc countLine(line: string, query: string): int =
  var n = 0
  var p = 0
  while true:
    p = line.find(query, p)
    if p >= 0:
      n += 1
      p += query.len
    else:
      break
  return n

proc count*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: count [OPTION]... QUERY [FILE]
    -n=<int>: show only lines have N of queries.
    -s=     : sort accending.
    -r=     : sort descending when with "-s".
"""
    stdout.write s

  var args: seq[string] = @[]
  var filter = -1
  var sort = false
  var reverse = false
  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        elif (kind == cmdShortOption and key == "n"):
           filter = val.parseInt
        elif (kind == cmdShortOption and key == "s"):
           sort = true
        elif (kind == cmdShortOption and key == "r"):
           reverse = true
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)

  let query = args[0]; args.delete(0)
  if sort:
    var count2str = initOrderedTable[int,seq[string]]()
    for line in readLinesFromFileOrStdin(args):
      let n = countLine(line, query)
      if not count2str.contains(n):
        count2str[n] = @[]
      count2str[n].add(line)
    if not reverse:
      for k in count2str.keys:
        echo count2str[k].join("\n")
    else:
      var kk:seq[int] = @[]
      for k in count2str.keys:
        kk.add(k)
      for k in kk.reversed:
        echo count2str[k].join("\n")
  else:
    var found_forN = false
    for line in readLinesFromFileOrStdin(args):
      let n = countLine(line, query)
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

