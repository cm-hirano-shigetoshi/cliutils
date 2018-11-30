import strutils
import getopts

var args: seq[string] = @[]
var bbb = ""
for kind, key, val in getopts():
  if kind == cmdArgument:
    args.add(key)
  elif kind == cmdShortOption and key == "B":
    bbb = val
  elif kind == cmdLongOption and key == "B":
    bbb = val
  else:
    #usage()
    stderr.writeline("Parse error.")
    quit(1)

echo "arg = \"", args.join("\",\""), "\"\tbbb = \"", bbb, "\""
