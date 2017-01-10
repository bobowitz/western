extends Node

# to add an item:
# add constant here w/ tileset frame (MUST BE CONTINUOUS, NO GAPS)
# add 1 to ITEMS constant
# add hitbox extents (Item.gd)
# actually use item (Item.set_ID())
#
# if it's a gun:
# add it to Item in Inventory.gd
# add it to Item.gd

var ITEMS = 10
var AMMO = 0
var MONEY = 1
var WHISKY = 2
var WATERMELON = 3

var FIRST_GUN = 4
var REVOLVER_TINY = 4 # this is the first revolver and frame 0 on the sprite sheet
var REVOLVER_SMALL = 5
var REVOLVER_MEDIUM = 6
var REVOLVER_LARGE = 7
var REVOLVER_HUGE = 8
var BANANA = 9