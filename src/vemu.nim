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
var line = ""
var cursor = 0

proc getE(): int =
  var s: int
  var t: int
  s = line.find(" ", cursor+2)
  t = line.find("\t", cursor+2)
  if s == -1 and t == -1:
    return line.len-1
  elif s == -1:
    return t-1
  elif t == -1:
    return s-1
  else:
    return min(s,t)-1

proc getW(): int =
  var p = getE()
  if p == -1:
    return p
  p += 2
  while $line[p] == " " or $line[p] == "\t":
    p += 1
    if p >= line.len:
      return -1
  return p

proc getB(): int =
  var s: int
  var t: int
  s = line.rfind(" ", cursor-2)
  t = line.rfind("\t", cursor-2)
  if s == -1 and t == -1:
    return 0
  elif s == -1:
    return t+1
  elif t == -1:
    return s+1
  else:
    return max(s,t)+1

proc getHead(): int =
  var p = 0
  while $line[p] == " " or $line[p] == "\t":
    p += 1
    if p >= line.len:
      return 0
  return p

proc pos(q: string): int =
  if q == "0":
    return 0
  if q == "^":
    return getHead()
  if q == "$" or q == "]" or q == "D":
    return line.len-1
  if q == "h":
    return max(cursor-1, 0)
  if q == "l":
    return min(cursor+1, line.len-1)
  if q == "E":
    return getE()
  if q == "W":
    return getW()
  if q == "B":
    return getB()

proc find(c: string): int =
  return line.find(c, cursor+1)

proc rfind(c: string): int =
  return line.rfind(c, cursor-1)

proc move(p: int) =
  if p >= 0:
    cursor = p

proc deleteForward(p: int) =
  if p >= 0:
    line = line[0 .. cursor-1] & line[p+1 .. line.len-1]
  else:
    line = line[0 .. cursor-1]

proc deleteTill(p: int) =
  if p >= 0:
    line = line[0 .. cursor-1] & line[p .. line.len-1]
  else:
    line = line[0 .. cursor-1]

proc deleteBackward(p: int) =
  line = line[cursor .. line.len-1]

proc unsupportedError(q: string) =
  stderr.writeline("[Error] Unsupported char: ", q)
  quit(1)


let query = args[0]; args.delete(0)
for orig_line in readLinesFromFileOrStdin(args):
  line = orig_line
  cursor = 0
  var i = 0
  while i < query.len:
    #stderr.writeline(cursor, ": ", query[i..query.len]) #debug
    #[ 1command ]#
    case $query[i]
    of "0", "^", "$", "]", "h", "l", "E", "W", "B":
      move(pos($query[i]))
    of "D":
      deleteForward(pos($query[i]))

    #[ 2commands ]#
    of "f":
      i += 1; move(find($query[i]))
    of "F":
      i += 1; move(rfind($query[i]))
    of "t":
      i += 1; move(find($query[i])-1)
    of "T":
      i += 1; move(rfind($query[i])+1)
    of "d":
      i += 1;
      case $query[i]:
      of "0":
        deleteBackward(pos($query[i]))
      of "l", "W":
        deleteTill(pos($query[i]))
      of "E", "$", "]":
        deleteForward(pos($query[i]))
      of "^":
        let head = getHead()
        if cursor < head:
          deleteTill(head)
        else:
          deleteBackward(head)
      else:
        unsupportedError($query[i])
    else:
      unsupportedError($query[i])
    i += 1
  #stderr.writeline(cursor) #debug
  echo line

