import strutils, tables, sets, nre
import ../lib/table, ../lib/io, ../lib/range, ../lib/getopts

proc column*() =
  shift_arg()
  proc usage() =
    let s = """
  Usage: column [OPTION]... PATTERN [FILE]
    -0      : index starts with 0.
    -v      : invert match.
    -d <str>: delimiter; default="\t".
    -r      : regex delimiter str.
    -C      : delimtier=",".
    -S      : use regex delimiter="\s+".
"""
    stdout.write s

  var args: seq[string] = @[]
  var delimiter = "\t"
  var regex = false
  var zero = false
  var invert = false

  for kind, key, val in getopts():
    if kind == cmdArgument:
      args.add(key)
    elif kind == cmdShortOption and key == "0":
      zero = true
    elif (kind == cmdShortOption and key == "v") or (kind == cmdLongOption and key == "invert"):
      invert = true
    elif (kind == cmdShortOption and key == "d"):
      delimiter = val
    elif (kind == cmdShortOption and key == "r"):
      regex = true
    elif (kind == cmdShortOption and key == "C"):
      delimiter = ","
    elif (kind == cmdShortOption and key == "S"):
      delimiter = "\\s+"
      regex = true
    else:
      usage()
      quit(0)
  if args.len < 1:
    args.add(":")

  let query = args[0]; args.delete(0)
  let lines = readAllFromFileOrStdin(args)
  let data = getMatrix(lines, delimiter, regex)
  var indices = getRange(query, data[0].len, zero)

  if invert:
    var excludes = initSet[int]()
    for i in indices:
      excludes.incl(i)
    indices = @[]
    for i in 0 .. data[0].len-1:
      if not excludes.contains(i):
        indices.add(i)

  if regex:
    delimiter = "\t"
  for y in 0..<data.len:
    var str = ""
    for x in indices:
      str &= data[y][x]
      str &= delimiter
    echo str[0..str.len-delimiter.len-1]

