import strutils, tables, sets, nre
import ../lib/io, ../lib/getopts

proc shift*() =
  shift_arg()
  proc usage() =
    let s = """
  Usage: shift [OPTION]... PATTERN [FILE]
    -n <int>: show N islands.
    -v      : inverse.
    -t      : split with "\\t".
    -c      : split with ",".
"""
    stdout.write s

  var args: seq[string] = @[]
  var n = 1
  var inverse = false
  var delimiter = 0

  for kind, key, val in getopts():
    if kind == cmdArgument:
      args.add(key)
    elif (kind == cmdShortOption and key == "n"):
      n = val.parseInt
    elif (kind == cmdShortOption and key == "v"):
      inverse = true
    elif (kind == cmdShortOption and key == "t"):
      delimiter = 1
    elif (kind == cmdShortOption and key == "c"):
      delimiter = 2
    else:
      usage()
      quit(0)

  proc setDelimiter(): Regex =
    if delimiter == 0:
      return re"\S+"
    elif delimiter == 1:
      return re"[^\t]+"
    elif delimiter == 2:
      return re"[^,]+"

  let d = setDelimiter()

  proc getLine(line: string): string =
    if not inverse:
      var s = 0
      var i = 0
      for m in line.findIter(d):
        s = m.matchBounds.a
        if i >= n:
          i = -1
          break
        i += 1
      if i >= 0 and n >= i:
        return ""
      return line[s .. line.len-1]
    else:
      var e = -1
      var i = 0
      for m in line.findIter(d):
        e = m.matchBounds.a - 1
        if i >= n:
          break
        i += 1
      if n >= i:
        return line
      return line[0 .. e]

  for line in readLinesFromFileOrStdin(args):
    echo getLine(line)

