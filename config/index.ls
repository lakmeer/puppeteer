
# Global Reference Constants

global.INTERACTION_MODE_IDLE   = Symbol \idle
global.INTERACTION_MODE_HOT    = Symbol \hot
global.INTERACTION_MODE_ACTIVE = Symbol \active

global.LINK_STATUS_OK       = Symbol \ok
global.LINK_STATUS_MISMATCH = Symbol \type-mismatch

global.KEY_Z = 90
global.KEY_X = 88
global.KEY_C = 67
global.KEY_V = 86

global.MOUSE_LEFT = 0
global.MOUSE_RIGHT = 2

global.COLOR_DARK_GREEN   = \green
global.COLOR_BRIGHT_GREEN = \#0e3
global.COLOR_YELLOW       = \#ff0
global.COLOR_RED          = \#f23
global.COLOR_DARK_RED     = \#812
global.COLOR_BRIGHT_RED   = \#f89
global.COLOR_DARK_BLUE    = \#118
global.COLOR_BRIGHT_BLUE  = \#48f
global.COLOR_PURPLE       = \#d4d
global.COLOR_MAGENTA      = \#f3f

global.SIGNAL_TYPE_POKE    = Symbol \poke
global.SIGNAL_TYPE_NUMBER  = Symbol \number
global.SIGNAL_TYPE_GRAPHIC = Symbol \graphic
global.SIGNAL_TYPE_TEXT    = Symbol \text


# Globally-available Service Locators

global.GlobalServices =
  Poke: poke: -> it

