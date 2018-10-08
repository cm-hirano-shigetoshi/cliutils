import osproc, streams, strutils, nre

proc execCmd*(s: string): int =
  return osproc.execCmd(s)

proc startProcess*(s: string): string =
  let p = startProcess(s, options={poEvalCommand})
  let s = p.outputStream()
  return s.readAll()

iterator iterProcess*(s: string): string =
  let p = startProcess(s, options={poEvalCommand})
  let s = p.outputStream()
  var line = ""
  while s.readline(line):
    yield line

