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


#Tue Sep 11 21:21:18 DST 2018
#0123456789012345678901234567
var cursor = 0


proc findEnd(line: string): int =
  var s: int
  var t: int
  s = line.find(" ", cursor+2)
  t = line.find("\t", cursor+2)
  if s == -1 and t == -1:
    return -1
  elif s == -1:
    return t - 1
  elif t == -1:
    return s - 1
  else:
    return min(s,t) - 1

proc findW(line: string): int =
  var i = findEnd(line)
  if i == -1:
    return i
  i += 1
  while $line[i] == " " or $line[i] == "\t":
    i += 1
  return i

proc operate(line: string, action: string, pos: string): string =
  var target = -1
  if pos == "END":
    target = findEnd(line)
  if action == "delete":
    if target >= 0:
      return line[0 .. cursor-1] & line[target+1 .. line.len-1]
    else:
      return line[0 .. cursor-1]

let query = args[0]; args.delete(0)

for orig_line in readLinesFromFileOrStdin(args):
  var query_index = 0
  var line = orig_line
  var action = ""
  var pos = ""
  cursor = 0
  while query_index < query.len:
    let q = $query[query_index]
    if action == "":
      if q == "D":
        line = line[0 .. cursor-1]
        query_index += 1
        continue
      if q == "d":
        action = "delete"
        query_index += 1
        continue
      if q == "f":
        action = "find"
        query_index += 1
        continue
      if q == "h":
        cursor = max(0, cursor-1)
        query_index += 1
        continue
      if q == "l":
        cursor += 1
        query_index += 1
        continue
      if q == "W":
        cursor = findW(line)
        query_index += 1
        continue
      if q == "E":
        cursor = findEnd(line)
        query_index += 1
        continue
    elif action == "find":
      cursor = line.find(q, cursor)
      action = ""
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
        continue
    stderr.write "Unsupported char: ", q
  echo line

