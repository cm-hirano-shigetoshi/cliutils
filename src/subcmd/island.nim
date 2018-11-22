import strutils, tables, parseopt, sets, nre
import ../lib/table, ../lib/io, ../lib/range

proc island*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: island [OPTION]... PATTERN [FILE]
    -0      : index starts with 0.
    -d <str>: delimiter; default="\s".
"""
    stdout.write s

  var args: seq[string] = @[]
  var delimiter = "\\s"
  var zero = false

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
        elif kind == cmdShortOption and key == "0":
          zero = true
        elif (kind == cmdShortOption and key == "d"):
          delimiter = val
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)
    if args.len < 1:
      args.add(":")

  let query = args[0]; args.delete(0)
  for line in readLinesFromFileOrStdin(args):
    let split = line.split(re(delimiter))
    var s = ""
    for i in getRange(query, split.len, zero):
      s &= split[i] & "\t"
    echo(s[0..s.len-2])

