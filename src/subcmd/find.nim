import strutils, parseopt, nre
import ../lib/cmd

proc find*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: replace [OPTION]... <before> <after> [FILE]
    -i      : ignore case.
    -b      : insert string to the prev position of matched.
    -a      : insert string to the next position of matched.
"""
    stdout.echo s

  var args: seq[string] = @[]
  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        #elif (kind == cmdShortOption and key == "i"):
          #ignore_case = true
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)

  #var ls = execCmd("ls -lR --color=always " & args.join(" ")).split("\n")
  echo execCmd("ls -lR --color=always " & args.join(" "))
