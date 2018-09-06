import strutils, parseopt, nre
import lib/io, lib/cmd

var args: seq[string] = @[]
var host = "localhost"
var port = "52225"

proc usage() =
  let s = """
Usage: clip [OPTION]... [FILE]
  -h <str>: hostname.
  -p <int>: port.
"""
  stdout.writeline(s)

try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    elif kind == cmdShortOption and key == "h":
      host = val
    elif kind == cmdShortOption and key == "p":
      port = val
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)

let str = readAllFromFileOrStdin(args).join("\n")
let command = "echo -n 'clipboard\n" & str & "' | nc " & host & " " & port
discard execCmd(command)

