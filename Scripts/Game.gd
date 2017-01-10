extends Node2D

var fullscreen = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	var w = WorldConstants.ROOM_SIZE.x
	var h = WorldConstants.ROOM_SIZE.y
	
	self.get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, \
									   SceneTree.STRETCH_ASPECT_KEEP, WorldConstants.ROOM_SIZE)
	OS.set_window_fullscreen(fullscreen)
	if(fullscreen):
		OS.set_window_size(OS.get_screen_size())
	else:
		OS.set_window_size(WorldConstants.ROOM_SIZE)
	OS.set_window_resizable(false)
	set_process(true)

func _process(delta):
	get_node("overlay/fps").set_text(str(OS.get_frames_per_second()))
	get_node("overlay/Crosshair").set_pos(get_viewport().get_mouse_pos())
	if(Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()