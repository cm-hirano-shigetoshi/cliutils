import sets, tables

proc search[T](a: openArray[T], x: T): int =
  var left  = 0
  var right = a.len-1
  while true:
    let center = int((left+right) / 2)
    if x < a[center]:
      if center == left:
        return center
      right = center-1
    elif x > a[center]:
      if center == right:
        return center+1
      left = center+1

###############
#[ SortedSet ]#
###############
type SortedSet*[T] = object
  s: seq[T]
  g: HashSet[T]

proc initSortedSet*[T](): SortedSet[T] =
  return SortedSet[T](s: @[], g: initSet[T]())

proc incl*[T](this: var SortedSet[T], x: T) {.inline.} =
  if this.g.contains(x):
    return
  this.g.incl(x)
  if this.s.len <= 0:
    this.s.add(x)
  else:
    this.s.insert(x, search(this.s, x))

proc contains*[T](this: SortedSet[T], k: T): bool {.inline.} =
  return this.g.contains(k)

proc get*[T](this: SortedSet[T], i: int): T {.inline.} =
  return this.s[i]

proc `[]`*[T](this: SortedSet[T], i: int): T {.inline.} =
  return this.s[i]

iterator items*[T](this: SortedSet[T]): T =
  var i = 0
  while i < this.s.len:
    yield this.s[i]
    i += 1


##################
#[ SortedSetRef ]#
##################
type SortedSetRef*[T] = ref SortedSet

proc initSortedSetRef*[T](): SortedSetRef[T] =
  return SortedSetRef[T](s: @[], g: initSet[T]())

proc incl*[T](this: var SortedSetRef[T], x: T) {.inline.} =
  if this.g.contains(x):
    return
  this.g.incl(x)
  if this.s.len <= 0:
    this.s.add(x)
  else:
    this.s.insert(x, search(this.s, x))

proc contains*[T](this: SortedSetRef[T], k: T): bool {.inline.} =
  return this.g.contains(k)

proc get*[T](this: SortedSetRef[T], i: int): T {.inline.} =
  return this.s[i]

proc `[]`*[T](this: SortedSetRef[T], i: int): T {.inline.} =
  return this.s[i]

iterator items*[T](this: SortedSetRef[T]): T =
  var i = 0
  while i < this.s.len:
    yield this.s[i]
    i += 1


#################
#[ SortedTable ]#
#################
type SortedTable*[K,V] = object
  s: seq[K]
  t: Table[K,V]

proc initSortedTable*[K,V](): SortedTable[K,V] =
  return SortedTable[K,V](s: @[], t: initTable[K,V]())

proc `[]=`*[K,V](this: var SortedTable[K,V], x: K, y: V) {.inline.} =
  if this.t.contains(x):
    return
  this.t[x] = y
  if this.s.len <= 0:
    this.s.add(x)
  else:
    this.s.insert(x, search(this.s, x))

proc contains*[K,V](this: SortedTable[K,V], k: K): bool {.inline.} =
  return this.t.contains(k)

proc get*[K,V](this: SortedTable[K,V], k: K): V {.inline.} =
  return this.t[k]

proc `[]`*[K,V](this: SortedTable[K,V], k: K): V {.inline.} =
  return this.t[k]

proc getAt*[K,V](this: SortedTable[K,V], i: int): V {.inline.} =
  return this.t[this.s[i]]

iterator pairs*[K,V](this: SortedTable[K,V]): (K,V) =
  var i = 0
  while i < this.s.len:
    yield (this.s[i], this.t[this.s[i]])
    i += 1

iterator keys*[K,V](this: SortedTable[K,V]): K =
  var i = 0
  while i < this.s.len:
    yield this.s[i]
    i += 1

iterator values*[K,V](this: SortedTable[K,V]): V =
  var i = 0
  while i < this.s.len:
    yield this.t[this.s[i]]
    i += 1


####################
#[ SortedTableRef ]#
####################
type SRefortedTable*[K,V] = object
  s: seq[K]
  t: Table[K,V]

proc initSRefortedTable*[K,V](): SRefortedTable[K,V] =
  return SRefortedTable[K,V](s: @[], t: initTable[K,V]())

proc `[]=`*[K,V](this: var SRefortedTable[K,V], x: K, y: V) {.inline.} =
  if this.t.contains(x):
    return
  this.t[x] = y
  if this.s.len <= 0:
    this.s.add(x)
  else:
    this.s.insert(x, search(this.s, x))

proc contains*[K,V](this: SRefortedTable[K,V], k: K): bool {.inline.} =
  return this.t.contains(k)

proc get*[K,V](this: SRefortedTable[K,V], k: K): V {.inline.} =
  return this.t[k]

proc `[]`*[K,V](this: SRefortedTable[K,V], k: K): V {.inline.} =
  return this.t[k]

proc getAt*[K,V](this: SRefortedTable[K,V], i: int): V {.inline.} =
  return this.t[this.s[i]]

iterator pairs*[K,V](this: SRefortedTable[K,V]): (K,V) =
  var i = 0
  while i < this.s.len:
    yield (this.s[i], this.t[this.s[i]])
    i += 1

iterator keys*[K,V](this: SRefortedTable[K,V]): K =
  var i = 0
  while i < this.s.len:
    yield this.s[i]
    i += 1

iterator values*[K,V](this: SRefortedTable[K,V]): V =
  var i = 0
  while i < this.s.len:
    yield this.t[this.s[i]]
    i += 1

