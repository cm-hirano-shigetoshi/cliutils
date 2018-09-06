import strutils, parseopt, nre, random, future
import ../lib/io

proc randomize*(tmpArgs: openArray[string]) =
  proc usage() =
    let s = """
  Usage: randomize [OPTION]... [FILE]
    -n <int>: show only required N lines."""
    echo s

  var args: seq[string] = @[]
  var requireN = 0

  if tmpArgs.len > 0:
    try:
      var p = initOptParser(@tmpArgs)
      for kind, key, val in getopt(p):
        if kind == cmdArgument:
          args.add(key)
        elif kind == cmdShortOption and key == "n":
          requireN = val.parseInt
        else:
          usage()
          quit(0)
    except:
      usage()
      quit(1)

  randomize()
  let lines = readAllFromFileOrStdin(args)
  var list = lc[x | (x <- 0 ..< lines.len), int]

  if 0 < requireN and requireN < lines.len:
    var counter = 0
    for i in countdown(lines.len-1, 1):
      let x = random.rand(i)
      echo lines[list[x]]
      counter += 1
      if counter >= requireN:
        quit(0)
      list[x] = list[i]
  else:
    for i in countdown(lines.len-1, 1):
      let x = random.rand(i)
      echo lines[list[x]]
      list[x] = list[i]
    echo lines[list[0]]

