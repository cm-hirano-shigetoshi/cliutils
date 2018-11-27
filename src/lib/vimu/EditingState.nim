type EditingState* = ref object of RootObj
  text*: string
  cursor*: int

