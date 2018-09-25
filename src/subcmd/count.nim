import strutils, parseopt, nre, tables, algorithm
import ../lib/io

proc filter(n: int, select :int, cmp: string): bool =
  if cmp == "":
    return n == select
  elif cmp == "+":
    return n >= select
  elif cmp == "<":
    return n < select
  elif cmp == ">":
    return n > select

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
    -n=<str>: show only lines have N of queries.
    -s=     : sort accending.
    -r=     : sort descending when with "-s".
"""
    stdout.write s

  var args: seq[string] = @[]
  var select = -1
  var cmp = ""
  var sort = false
  var reverse = false
  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        elif (kind == cmdShortOption and key == "n"):
          if val.endswith("+"):
            cmp = "+"
            select = val[0 .. val.len-2].parseInt
          elif val.startswith("<"):
            cmp = "<"
            select = val[1 .. val.len-1].parseInt
          elif val.startswith(">"):
            cmp = ">"
            select = val[1 .. val.len-1].parseInt
          else:
            select = val.parseInt
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
        if select == -1 or filter(k, select, cmp):
          echo count2str[k].join("\n")
    else:
      var kk:seq[int] = @[]
      for k in count2str.keys:
        kk.add(k)
      for k in kk.reversed:
        if select == -1 or filter(k, select, cmp):
          echo count2str[k].join("\n")
  else:
    var found_forN = false
    for line in readLinesFromFileOrStdin(args):
      let n = countLine(line, query)
      if select == -1:
        found_forN = true
        echo n
      elif filter(n, select, cmp):
        found_forN = true
        echo line
    if not found_forN:
      quit(1)
    else:
      quit(0)

