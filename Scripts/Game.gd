extends Node

var scale = 2

func _ready():
	self.get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, \
									   SceneTree.STRETCH_ASPECT_KEEP, Vector2(576, 384))
	OS.set_window_size(Vector2(576, 384))
	OS.set_window_resizable(false)
	set_process(true)

func _process(delta):
	get_node("fps").set_text(str(OS.get_frames_per_second()))