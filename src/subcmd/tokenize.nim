import strutils, nre
import ../lib/getopts, ../lib/io

proc tokenize*() =
  shift_arg()
  proc usage() =
    let s = """
  Usage: replace [OPTION]... <before> <after> [FILE]
    -i      : ignore case.
    -b      : insert string to the prev position of matched.
    -a      : insert string to the next position of matched.
"""
    stdout.write s

  var delimiters = "!\"#$%&'()=^|@`[{;:*]},<>?"

  var args: seq[string] = @[]
  for kind, key, val in getopts():
    if kind == cmdArgument:
      args.add(key)
    #elif (kind == cmdShortOption and key == "i"):
      #ignore_case = true
    else:
      usage()
      quit(0)

  for line in readLinesFromFileOrStdin(args):
    for i in 0 .. line.len-1:
      let c = $line[i]
      if delimiters.find(c) >= 0:
        stdout.writeline("")
      else:
        stdout.write(c)

