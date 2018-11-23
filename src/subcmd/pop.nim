import strutils, tables, parseopt, sets, nre
import ../lib/io

proc pop*(tmpArgs: openArray[string]) =
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

  var minusEvacuatedArgs: seq[string] = @[]
  for a in tmpArgs:
    if a != "-0" and a.match(re"^-[0-9]") != none(RegexMatch):
      minusEvacuatedArgs.add("" & a)
    else:
      minusEvacuatedArgs.add(a)

  if minusEvacuatedArgs.len > 0:
    try:
      var p = initOptParser(minusEvacuatedArgs)
      for kind, key, val in getopt(p):
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
    except:
      usage()
      quit(1)

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

