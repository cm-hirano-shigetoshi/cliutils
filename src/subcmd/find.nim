import strutils, nre
import ../lib/cmd, ../lib/getopts

proc find*() =
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
  for kind, key, val in getopts():
    if kind == cmdArgument:
      args.add(key)
    #elif (kind == cmdShortOption and key == "i"):
      #ignore_case = true
    else:
      usage()
      quit(0)

  #var ls = startProcess("ls -lR --color=always " & args.join(" ")).split("\n")
  echo startProcess("ls -lR --color=always " & args.join(" "))
