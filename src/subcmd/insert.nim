import strutils, parseopt, nre
import ../lib/io

proc insert*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: insert [OPTION]... <query> [FILE]
    -i=<str>: insert into front of matched.
    -a=<str>: insert into back of matched.
    -0=<str>: insert into line head.
    -I=<str>: insert into line head (like Vim's '^').
    -A=<str>: append into line end.
    -o=<str>: insert the next line.
    -O=<str>: insert the previouos line.
"""
    stdout.write s

  var args: seq[string] = @[]
  var str_i, str_a, str_0, str_ci, str_ca, str_o, str_co = ""

  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        elif (kind == cmdShortOption and key == "i"):
          str_i = val
        elif (kind == cmdShortOption and key == "a"):
          str_a = val
        elif (kind == cmdShortOption and key == "0"):
          str_0 = val
        elif (kind == cmdShortOption and key == "I"):
          str_ci = val
        elif (kind == cmdShortOption and key == "A"):
          str_ca = val
        elif (kind == cmdShortOption and key == "o"):
          str_o = val
        elif (kind == cmdShortOption and key == "O"):
          str_co = val
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)

  if str_i.len + str_a.len + str_0.len + str_ci.len + str_ca.len + str_o.len + str_co.len == 0:
    for line in readLinesFromFileOrStdin(args):
      echo line
    quit(0)

  let query = args[0]; args.delete(0)
  #stderr.writeline("query = \"", query, "\"") #debug

  for line in readLinesFromFileOrStdin(args):
    var l = line
    var found = false
    var p = l.rfind(query)
    while p >= 0:
      found = true
      if str_a.len > 0:
        l = l[0 .. p+query.len-1] & str_a & l[p+query.len .. l.len-1]
      if str_i.len > 0:
        l = l[0 .. p-1] & str_i & l[p .. l.len-1]
      p = l.rfind(query, p)
    if found:
      if str_ca.len > 0:
        l &= str_ca
      if str_ci.len > 0:
        var head = l.len
        for m in l.findIter(re"\S"):
          head = m.matchBounds.a
          break
        l = l[0 .. head-1] & str_ci & l[head .. l.len-1]
      if str_0.len > 0:
        l = str_0 & l
      if str_o.len > 0:
        l = l & "\n" & str_o
      if str_co.len > 0:
        l = str_co & "\n" & l
    echo l

