import strutils, nre

var Length: int
var Zero: bool
var Indices: seq[int]

proc toIndex(n: int): int =
  if n == 0:
    return 0
  elif n > 0:
    if Zero:
      return n
    else:
      return n-1
  elif n < 0:
    return Length + n

proc addAll() =
  for n in 0 .. Length-1:
    Indices.add(n)

proc addFrom(start: int) =
  for n in start.toIndex .. Length-1:
    Indices.add(n)

proc addUntil(last: int) =
  for n in 0.toIndex .. last.toIndex:
    Indices.add(n)

proc addFromtTo(start: int, last: int) =
  for n in start.toIndex .. last.toIndex:
    Indices.add(n)

proc addModulo(num: int, modulo: int) =
  if Zero:
    for i in 0 .. Length-1:
      if i mod num == modulo:
        Indices.add(i)
  else:
    for i in 1 .. Length:
      if i mod num == modulo:
        Indices.add(i-1)

proc addEach(query: string) =
  for i in query.split(","):
    if i.len > 0:
      Indices.add(i.parseInt.toIndex)

proc getRange*(q: string, length: int, zero: bool): seq[int] =
  Length = length;
  Zero = zero
  Indices = @[]

  var m: Option[RegexMatch]
  for query in q.split(","):
    m = query.match(re"^-?\d+$"); if m != none(RegexMatch):
      addEach(query)
      continue
    if query == ":" or query == "..":
      addAll()
      continue
    m = query.match(re"^(-?[0-9]+)(:|\.\.)$"); if m != none(RegexMatch):
      # 2..
      let first  = m.get.captures[0].parseInt
      addFrom(first)
      continue
    m = query.match(re"^(:|\.\.)(-?[0-9]+)$"); if m != none(RegexMatch):
      # ..2
      let op = m.get.captures[0]
      let second  = m.get.captures[1].parseInt
      if op == ":":
        addUntil(second-1)
      elif op == "..":
        addUntil(second)
      continue
    m = query.match(re"^(-?[0-9]+)(:|\.\.)(-?[0-9]+)$"); if m != none(RegexMatch):
      # 2..5
      let op = m.get.captures[1]
      let first  = m.get.captures[0].parseInt
      let second = m.get.captures[2].parseInt
      if op == ":":
        if second == 0:
          addFromtTo(first, 0)
        else:
          addFromtTo(first, second-1)
      elif op == "..":
        addFromtTo(first, second)
      continue
    m = query.match(re"^%([0-9]+)$"); if m != none(RegexMatch):
      # %2
      let first  = m.get.captures[0].parseInt
      addModulo(first, 0)
      continue
    m = query.match(re"^%([0-9]+)==?([0-9]+)$"); if m != none(RegexMatch):
      # %2=0
      let first  = m.get.captures[0].parseInt
      let second = m.get.captures[1].parseInt
      addModulo(first, second)
      continue
  return Indices

