extends Node

var OUTLINE_COLOR = Color("311f2f")
var HIGHLIGHT_COLOR = Color("ffffff")
var HEALTH_GREEN = Color("55c477")
var HEALTH_RED = Color("ff4466")
var ROOM_SIZE = Vector2(576, 384)

var AREA_W = 5
var AREA_H = 5
var AREA_SIZE = Vector2(AREA_W, AREA_H)

var TOWN_NORMAL = 0
var TOWN_WASTELAND = 1

var ENEMY_AREA = Rect2(128, 128, ROOM_SIZE.x - 128 * 2, ROOM_SIZE.y - 128 * 2)

var WASTELAND = 0
var SALOON = 1
var INN = 2
var WALL_N = 3
var WALL_NW = 4
var WALL_W = 5
var WALL_SW = 6
var WALL_S = 7
var WALL_SE = 8
var WALL_E = 9
var WALL_NE = 10
var WALL_CORNER_NW = 11
var WALL_CORNER_SW = 12
var WALL_CORNER_SE = 13
var WALL_CORNER_NE = 14
var WALL_DESTROY_N = 15
var WALL_DESTROY_W = 16
var WALL_DESTROY_S = 17
var WALL_DESTROY_E = 18