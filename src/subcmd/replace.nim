import strutils, nre
import ../lib/io, ../lib/getopts

proc replace*() =
  shift_arg()
  proc usage() =
    let s = """
  Usage: replace [OPTION]... <before> <after> [FILE]
    -i      : ignore case.
    -b      : insert string to the prev position of matched.
    -a      : insert string to the next position of matched.
"""
    stdout.write s

  var args: seq[string] = @[]
  var ignore_case = false
  var insert = 0

  for kind, key, val in getopts():
    if kind == cmdArgument:
      args.add(key)
    elif (kind == cmdShortOption and key == "i"):
      ignore_case = true
    elif (kind == cmdShortOption and key == "b"):
      insert = -1
    elif (kind == cmdShortOption and key == "a"):
      insert = 1
    else:
      usage()
      quit(0)

  var before = args[0]; args.delete(0)
  var after  = args[0]; args.delete(0)

  if ignore_case:
    before = before.toLowerAscii
  for line in readLinesFromFileOrStdin(args):
    var l = line
    if ignore_case:
      l = l.toLowerAscii
    if insert == 0:
      l = l.replace(before, after)
    elif insert == -1:
      var p = l.rfind(before)
      while p >= 0:
        l = l[0 .. p-1] & after & l[p .. l.len-1]
        p = l.rfind(before, p)
    elif insert == 1:
      var p = l.rfind(before)
      while p >= 0:
        l = l[0 .. p+before.len-1] & after & l[p+before.len .. l.len-1]
        p = l.rfind(before, p)
    echo l

