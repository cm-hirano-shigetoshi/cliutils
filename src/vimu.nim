import lib/io, lib/getopts
import lib/vimu/Core

proc usage() =
  let s = """
Usage: vimu <COMMAND> [FILE]
"""
  stdout.writeline(s)

var args: seq[string] = @[]
for kind, key, val in getopts():
  if kind == cmdArgument:
    args.add(key)
  else:
    usage()
    quit(0)

let query = args[0]; args.delete(0)
let vimu = initVimu(query)
for line in readLinesFromFileOrStdin(args):
  echo vimu.exec(line)

