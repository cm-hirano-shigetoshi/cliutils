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


#Tue Sep 11 21:21:18 JST 2018
#0123456789012345678901234567
var line = ""
var cursor = 0
var repeat = 0

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
  return line.rfind(c, cursor+1)

proc till(c: string): int =
  return line.find(c, cursor+1) - 1

proc rtill(c: string): int =
  let p = line.rfind(c, cursor-1)
  if p == -1:
    return -1
  return p + 1

proc move(p: int) =
  if p >= 0:
    cursor = p

proc deleteForward(p: int) =
  if p >= 0:
    line = line[0 .. cursor-1] & line[p+1 .. line.len-1]

proc deleteBackward(p: int) =
  if p >= 0:
    line = line[0 .. p] & line[cursor .. line.len-1]

proc blockEnd() =
  repeat = 0

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
    of "1", "2", "3", "4", "5", "6", "7", "8", "9":
      if repeat > 0:
        repeat = repeat * 10 + parseInt($query[i])
      else:
        repeat = parseInt($query[i])
    of "0":
      if repeat > 0:
        repeat = repeat * 10
      else:
        move(pos($query[i]))
        blockEnd()
    of "^", "$", "]", "h", "l", "E", "W", "B":
      repeat = max(repeat, 1)
      for r in 1 .. repeat:
        move(pos($query[i]))
      blockEnd()
    of "D":
      deleteForward(pos($query[i]))
      blockEnd()

    #[ 2commands ]#
    of "f":
      i += 1; move(find($query[i]))
      blockEnd()
    of "F":
      i += 1; move(rfind($query[i]))
      blockEnd()
    of "t":
      i += 1; move(till($query[i]))
      blockEnd()
    of "T":
      i += 1; move(rtill($query[i]))
      blockEnd()
    of "d":
      i += 1
      case $query[i]:
      of "0":
        deleteBackward(pos($query[i]))
        blockEnd()
      of "l", "W":
        deleteForward(pos($query[i])-1)
        blockEnd()
      of "E", "$", "]":
        deleteForward(pos($query[i]))
        blockEnd()
      of "^":
        let head = getHead()
        if cursor < head:
          deleteForward(head-1)
        else:
          deleteBackward(head)
        blockEnd()
      of "f":
        i += 1
        let target = find($query[i])
        deleteForward(target)
        blockEnd()
      of "F":
        i += 1
        let target = rfind($query[i])
        deleteBackward(target-1)
        blockEnd()
      of "t":
        i += 1
        let target = till($query[i])
        deleteForward(target)
        blockEnd()
      of "T":
        i += 1
        let target = rtill($query[i])
        deleteBackward(target-1)
        blockEnd()
      else:
        unsupportedError($query[i])
    else:
      unsupportedError($query[i])
    i += 1
  #stderr.writeline(cursor) #debug
  echo line

