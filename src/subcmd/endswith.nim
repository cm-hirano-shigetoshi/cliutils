import strutils, parseopt, nre
import ../lib/io

proc endswith*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: endswith [OPTION]... QUERY [FILE]
    -i      : ignore case.
    -m      : remove coloring.
    -s      : remove leading spaces."""
    echo s

  var ignore_case = false
  var monochrome = false
  var remove_space = false

  var args: seq[string] = @[]
  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        elif (kind == cmdShortOption and key == "i"):
          ignore_case = true
        elif (kind == cmdShortOption and key == "m"):
          monochrome = true
        elif (kind == cmdShortOption and key == "s"):
          remove_space = true
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)

  var matchN = 0
  var query = args[0]; args.delete(0)
  if ignore_case:
    query = query.toLowerAscii
  for orig_line in readLinesFromFileOrStdin(args):
    var l = orig_line
    if ignore_case:
      l = l.toLowerAscii
    if monochrome:
      l = l.replace(re"\[\d+m","")
    if remove_space:
      l = l.replace(re"^\s+","")
    if not l.endswith(query):
      continue
    echo orig_line
    matchN += 1
  if matchN == 0:
    quit(1)

