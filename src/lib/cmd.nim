import osproc, streams

proc execCmd*(s: string): string =
  let p = startProcess(s, options={poEvalCommand})
  let s = p.outputStream()
  return s.readAll()

