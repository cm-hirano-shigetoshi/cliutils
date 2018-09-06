type Element[T] = ref object
  next: Element[T]
  prev: Element[T]
  data: T

type LinkedList*[T] = ref object
  first: Element[T]
  last:  Element[T]
  length: int

proc nthElement[T](l: LinkedList[T], n: int): Element[T] =
  var e: Element[T]
  if n < int(l.length/2):
    e = l.first
    for i in 1 ..< n:
      e = e.next
  else:
    e = l.last
    for i in n .. l.length-1:
      e = e.prev
  return e

proc insert*[T](l: LinkedList[T], x: T, n: int) =
  let p = Element[T](data: x)
  if n == 0:
    if l.length == 0:
      l.first = p
      l.last  = p
    else:
      p.next = l.first
      l.first.prev = p
      l.first = p
  elif n == l.length:
    p.prev = l.last
    l.last.next = p
    l.last = p
  else:
    let e = nthElement(l, n-1)
    p.next = e.next
    p.prev = e
    e.next = p
    p.next.prev = p
  l.length += 1

proc add*[T](l: LinkedList[T], x: T) =
  l.insert(x, l.length)

proc remove*[T](l: LinkedList[T], n: int) =
  if l.length == 1 and n == 0:
    l.first = nil
    l.last  = nil
  elif n == 0:
    l.first = l.first.next
    l.first.prev = nil
  elif n == l.length - 1:
    l.last = l.last.prev
    l.last.next = nil
  else:
    let e = nthElement(l, n)
    e.prev.next = e.next
    e.next.prev = e.prev
  l.length -= 1

proc extract*[T](l: LinkedList[T], n: int): T =
  var x: T
  if l.length == 1 and n == 0:
    x = l.first.data
    l.first = nil
    l.last  = nil
  elif n == 0:
    x = l.first.data
    l.first = l.first.next
    l.first.prev = nil
  elif n == l.length - 1:
    x = l.last.data
    l.last = l.last.prev
    l.last.next = nil
  else:
    let e = nthElement(l, n)
    x = e.next.data
    e.prev.next = e.next
    e.next.prev = e.prev
  l.length -= 1
  return x

proc poll*[T](l: LinkedList[T]): T =
  l.extract(0)

proc pop*[T](l: LinkedList[T]): T =
  l.extract(l.length - 1)

proc get*[T](l: LinkedList[T], n: int): T =
  return nthElement(l, n)

proc `[]`*[T](l: LinkedList[T], n: int): T =
  return l.get(n)

iterator items*[T](l: LinkedList[T]): T =
  if l.first != nil:
    var e = l.first
    while true:
      yield e.data
      if e.next != nil:
        e = e.next
      else:
        break

iterator ritems*[T](l: LinkedList[T]): T =
  if l.last != nil:
    var e = l.last
    while true:
      yield e.data
      if e.prev != nil:
        e = e.prev
      else:
        break

