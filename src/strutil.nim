import strutils, nre, os
import subcmd/de
import subcmd/startswith
import subcmd/endswith
import subcmd/transpose
import subcmd/newline
import subcmd/randomize
import subcmd/replace
import subcmd/unique
import subcmd/line
import subcmd/column
import subcmd/island
import subcmd/shift
import subcmd/pop
import subcmd/count
import subcmd/preg

proc usage() =
  let s = """
Usage: strutil <COMMAND> [OPTIONS]... [FILE]
  de         : delete leading one word for each line.
  startswith : filter lines such as startwith given string.
  endswith   : filter lines such as endwith given string.
  transpose  : transposed text from table.
  newline    : editor for \n.
  randomize  : randomize lines.
  replace    : ordinary replace method.
  unique     : unique lines with original order.
  line       : select lines.
  column     : select columns from table.
  island     : select islands.
  shift      : shift first island.
  pop        : pop last island.
  count      : count specified string for each line.
  preg       : print lines match with input.
"""
  stdout.writeline(s)

proc run(cmd: string) =
  if cmd == "-h" or cmd == "--help": usage(); quit(0)
  elif cmd == "de"         :de         (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "startswith" :startswith (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "endswith"   :endswith   (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "transpose"  :transpose  (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "newline"    :newline    (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "randomize"  :randomize  (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "replace"    :replace    (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "unique"     :unique     (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "line"       :line       (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "column"     :column     (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "island"     :island     (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "shift"      :shift      (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "pop"        :pop        (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "count"      :count      (os.commandLineParams()[1..os.commandLineParams().len-1])
  elif cmd == "preg"       :preg       (os.commandLineParams()[1..os.commandLineParams().len-1])

if paramCount() == 0:
  usage()
  quit(0)

run(os.commandLineParams()[0])

