import strutils, nre
import ../lib/io, ../lib/getopts

proc insert*() =
  shift_arg()
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
    -r      : regex.
"""
    stdout.write s

  var args: seq[string] = @[]
  var str_i, str_a, str_0, str_ci, str_ca, str_o, str_co = ""
  var regex = false

  for kind, key, val in getopts():
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
    elif (kind == cmdShortOption and key == "r"):
      regex = true
    else:
      usage()
      quit(0)

  if str_i.len + str_a.len + str_0.len + str_ci.len + str_ca.len + str_o.len + str_co.len == 0:
    for line in readLinesFromFileOrStdin(args):
      echo line
    quit(0)

  let query = args[0]; args.delete(0)
  #stderr.writeline("query = \"", query, "\"") #debug

  proc add_each_pos(line: var string, p: int) =
    if str_a.len > 0:
      line = line[0 .. p+query.len-1] & str_a & line[p+query.len .. line.len-1]
    if str_i.len > 0:
      line = line[0 .. p-1] & str_i & line[p .. line.len-1]

  proc add_each_line(line: var string) =
    if str_ca.len > 0:
      line &= str_ca
    if str_ci.len > 0:
      var head = line.len
      for m in line.findIter(re"\S"):
        head = m.matchBounds.a
        break
      line = line[0 .. head-1] & str_ci & line[head .. line.len-1]
    if str_0.len > 0:
      line = str_0 & line
    if str_o.len > 0:
      line = line & "\n" & str_o
    if str_co.len > 0:
      line = str_co & "\n" & line

  for l in readLinesFromFileOrStdin(args):
    var line = l
    var matched = false
    if not regex:
      var p = line.rfind(query)
      while p >= 0:
        matched = true
        add_each_pos(line, p)
        p = line.rfind(query, p)
      if matched:
        add_each_line(line)
    else:
      var matches: seq[RegexMatch] = @[]
      for m in line.findIter(re(query)):
        matched = true
        matches.add(m)
      for i in countdown(matches.len-1, 0):
        let p = matches[i].matchBounds.a
        add_each_pos(line, p)
      if matched:
        add_each_line(line)
    echo line

