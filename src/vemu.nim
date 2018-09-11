import strutils, parseopt, nre, os
import lib/io

proc usage() =
  let s = """
Usage: strutil <COMMAND> [OPTIONS]... [FILE]
  de         : delete leading one word for each line.
"""
  stdout.writeline(s)

var args: seq[string] = @[]
try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    #elif (kind == cmdShortOption and key == "n"):
      #repeatN = val.parseInt
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)


let cursor = 0

proc findRange(): int =
  return 4

proc operate(line: string, action: string, pos: string): string =
  var target = -1
  if pos == "END":
    target = findRange()
  if action == "delete":
    echo "line[0..", cursor-1, "] & line[", cursor+target+1, "..", line.len-1, "]"
    return line[0 .. cursor-1] & line[cursor+target+1 .. line.len-1]

let query = args[0]; args.delete(0)

for orig_line in readLinesFromFileOrStdin(args):
  var query_index = 0
  var line = orig_line
  var action = ""
  var pos = ""
  while query_index < query.len:
    let q = $query[query_index]
    if action == "":
      if q == "d":
        action = "delete"
        query_index += 1
        continue
    else:
      if q == "E":
        pos="END"
        line = operate(line, action, pos)
        action = ""
        pos = ""
        query_index += 1
        echo line
        break
        #continue

