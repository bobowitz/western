extends Node

func _ready():
	self.get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, \
									   SceneTree.STRETCH_ASPECT_KEEP, Vector2(544, 544))
	OS.set_window_size(Vector2(544, 544))
	OS.set_window_resizable(false)