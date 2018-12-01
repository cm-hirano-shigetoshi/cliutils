import strutils, nre
import ../lib/io, ../lib/getopts

proc preg*() =
  shift_arg()
  proc usage() =
    let s = """
  Usage: preg [OPTION]... [FILE]
    -1      : show only first one found.
    -r      : use 1st column is regexp.
"""
    stdout.write s

  var args: seq[string] = @[]
  var only_first = false
  var regexp = false

  for kind, key, val in getopts():
    if kind == cmdArgument:
      args.add(key)
    elif kind == cmdShortOption and key == "1":
      only_first = true
    elif kind == cmdShortOption and key == "r":
      regexp = true
    else:
      usage()
      quit(0)

  let input = args[0]; args.delete(0)

  for line in readLinesFromFileOrStdin(args):
    var (query, text) = ("", "")
    for x in line.findIter(re"\t+"):
      query = line[0 .. x.matchBounds.a-1]
      text = line[x.matchBounds.b+1 .. line.len-1]
      break
    #stderr.writeline("\"", input, "\" =~ /", query, "/") #debug
    if not regexp:
      if input.find(query) >= 0:
        echo text
        if only_first:
          break
    else:
      let m = input.find(re(query)); if m.isSome():
        echo text
        if only_first:
          break
