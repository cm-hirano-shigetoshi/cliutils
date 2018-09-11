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
    return -1
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

proc pos(q: string): int =
  if q == "h":
    return max(cursor-1, 0)
  if q == "l":
    return min(cursor+1, line.len-1)
  if q == "E":
    return getE()
  if q == "W":
    return getW()
  stderr.writeline("Unsupported char: ", q)

proc find(c: string): int =
  return line.find(c, cursor+1)

proc rfind(c: string): int =
  return line.rfind(c, cursor-1)

proc move(p: int) =
  if p >= 0:
    cursor = p

proc delete(p: int) =
  if p >= 0:
    line = line[0 .. cursor-1] & line[p+1 .. line.len-1]
  else:
    line = line[0 .. cursor-1]


let query = args[0]; args.delete(0)
for orig_line in readLinesFromFileOrStdin(args):
  line = orig_line
  cursor = 0
  var i = 0
  while i < query.len:
    let q = $query[i]

    #[ 1command ]#
    case q
    of "h", "l", "E", "W":
      move(pos(q))
    of "D":
      delete(line.len-1)

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
      i += 1; delete(pos($query[i])-1)
    i += 1
  echo line

