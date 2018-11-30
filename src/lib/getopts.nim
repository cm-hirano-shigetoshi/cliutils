import parseopt, os, nre
export parseopt

var tmp_args: seq[string] = @[]
var argument_flag = false
for a in os.commandLineParams():
  #stderr.writeline("raw_arg=\"", a, "\"") #debug
  if a == "--":
    argument_flag = true
    continue
  let m = a.match(re"^(--?[A-Za-z]+[=:])( .*)$")
  if m.isSome:
    tmp_args.add(m.get.Captures[0] & "" & m.get.Captures[1])
    continue
  if argument_flag:
    tmp_args.add("" & a)
  else:
    tmp_args.add(a)

iterator getopts*(): tuple[kind: CmdLineKind, key, val: TaintedString] =
  var p = initOptParser(tmp_args)
  for kind, key, val in getopt(p):
    #stderr.writeline("key=\"", key, "\" val=\"", val, "\"") #debug
    if $key[0] == "":
      yield (kind, key[1..key.len-1], val)
    if $val[0] == "":
      yield (kind, key, val[1..val.len-1])
    else:
      yield (kind, key, val)

