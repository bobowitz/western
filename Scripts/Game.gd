extends Node

var scale = Vector2(2, 2)

func _ready():
	self.get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, \
									   SceneTree.STRETCH_ASPECT_KEEP, Vector2(576, 384) * scale)
	OS.set_window_size(Vector2(576*2, 384*2))
	OS.set_window_resizable(false)
	set_process_input(true)

func _input(event):
	if(event.is_action_pressed("ui_page_down")):
		scale *= 2
		self.get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, \
									   SceneTree.STRETCH_ASPECT_KEEP, Vector2(576, 384) * scale)
	if(event.is_action_pressed("ui_page_up")):
		scale /= 2
		self.get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, \
									   SceneTree.STRETCH_ASPECT_KEEP, Vector2(576, 384) * scale)