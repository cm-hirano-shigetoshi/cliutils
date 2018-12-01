import strutils, tables, sets, nre
import ../lib/io, ../lib/getopts

proc pop*() =
  shift_arg()
  proc usage() =
    let s = """
  Usage: pop [OPTION]... PATTERN [FILE]
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
      if key.match(re"^-[0-9]") != none(RegexMatch):
        args.add(key[1..key.len-1])
      else:
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
      var e = line.len
      var matches: seq[RegexMatch] = @[]
      for m in line.findIter(d):
        matches.add(m)
      if matches.len == 0:
        return ""
      if n >= matches.len:
        return ""
      e = matches[matches.len-n-1].matchBounds.b
      return line[0 .. e]
    else:
      var s = -1
      var matches: seq[RegexMatch] = @[]
      for m in line.findIter(d):
        matches.add(m)
      if matches.len == 0:
        return ""
      if n >= matches.len:
        return line
      for i in countdown(matches.len-1, matches.len-n-1):
        s = matches[i].matchBounds.b + 1
      return line[s .. line.len-1]

  for line in readLinesFromFileOrStdin(args):
    echo getLine(line)

