extends Node2D

signal tween_finished

var ROOM_CHANGE_TWEEN_SPEED = 0.5
var position = Vector2(0, 0) # in pixels
var target_position = Vector2(0, 0) # in pixels
var transform = Matrix32()
var shake_mag = Vector2(0, 0)

func set_pixel_pos(pos): # units are pixels
	position = pos

func get_pixel_pos(): # units are pixels
	return position

func set_room_pos(pos): # units are rooms, DON'T USE WITH NON-INTEGER VALUES
	position = pos * WorldConstants.ROOM_SIZE
	target_position = position

func get_room_pos(): # units are rooms
	return (target_position / WorldConstants.ROOM_SIZE).floor()

func shake(magnitude):
	shake_mag = magnitude

func move_rooms_tween(transform): # units are rooms
	get_node("Tween").interpolate_method(self, \
		"set_pixel_pos", \
		get_pixel_pos(), get_pixel_pos() + transform * WorldConstants.ROOM_SIZE, \
		ROOM_CHANGE_TWEEN_SPEED, Tween.TRANS_LINEAR, Tween.EASE_IN)
	get_node("Tween").start()
	target_position = get_pixel_pos() + transform * WorldConstants.ROOM_SIZE

func move_rooms(transform): # units are rooms
	set_room_pos(get_room_pos() + transform)
	target_position = position

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var shake_offset = shake_mag
	shake_mag *= -0.75
	transform[2] = -position + shake_offset # move transform origin vector
	get_viewport().set_canvas_transform(transform)

func _on_tween_complete(object, key):
	emit_signal("tween_finished")