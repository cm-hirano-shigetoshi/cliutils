import strutils, tables, sets, nre
import ../lib/table, ../lib/io, ../lib/getopts

proc transpose*() =
  shift_arg()
  proc usage() =
    let s = """
  Usage: transpose [OPTION]... [FILE]
    -d <str>: delimiter; default="\t".
    -r    : regex delimiter str.
    -C    : delimtier=",".
    -S    : use regex delimiter="\s+".
"""
    stdout.write s

  var args: seq[string] = @[]
  var delimiter = "\t"
  var regex = false

  for kind, key, val in getopts():
    if kind == cmdArgument:
      args.add(key)
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

  let lines = readAllFromFileOrStdin(args)
  let data = getMatrix(lines, delimiter, regex)
  if regex:
    delimiter = "\t"
  for y in 0..<data[0].len:
    var str = ""
    for x in 0..<data.len:
      str &= data[x][y]
      str &= delimiter
    echo str[0..str.len-delimiter.len-1]

