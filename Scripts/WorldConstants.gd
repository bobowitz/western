extends Node

var ROOM_SIZE = Vector2(576, 384)

var AREA_W = 8
var AREA_H = 8
var AREA_SIZE = Vector2(AREA_W, AREA_H)

var ENEMY_AREA = Rect2(64, 64, ROOM_SIZE.x - 64 * 2, ROOM_SIZE.y - 64 * 2)

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