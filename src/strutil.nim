import strutils, nre, os
import subcmd/transpose
import subcmd/newline
import subcmd/replace
import subcmd/insert
import subcmd/unique
import subcmd/line
import subcmd/column
import subcmd/island
import subcmd/shift
import subcmd/pop
import subcmd/count
import subcmd/preg
import subcmd/tokenize

proc usage() =
  let s = """
Usage: strutil <COMMAND> [OPTIONS]... [FILE]
  transpose  : transposed text from table.
  newline    : editor for \n.
  replace    : ordinary replace method.
  insert     : insert strings to lines which match a query.
  unique     : unique lines with original order.
  line       : select lines.
  column     : select columns from table.
  island     : select islands.
  shift      : shift first island.
  pop        : pop last island.
  count      : count specified string for each line.
  preg       : print lines match with input.
  tokenize   : smart tokenize.
"""
  stdout.writeline(s)

proc run(cmd: string) =
  if cmd == "-h" or cmd == "--help": usage(); quit(0)
  elif cmd == "transpose"  :transpose()
  elif cmd == "newline"    :newline()
  elif cmd == "replace"    :replace()
  elif cmd == "insert"     :insert()
  elif cmd == "unique"     :unique()
  elif cmd == "line"       :line()
  elif cmd == "column"     :column()
  elif cmd == "island"     :island()
  elif cmd == "shift"      :shift()
  elif cmd == "pop"        :pop()
  elif cmd == "count"      :count()
  elif cmd == "preg"       :preg()
  elif cmd == "tokenize"   :tokenize()

if paramCount() == 0:
  usage()
  quit(0)

run(os.commandLineParams()[0])

