extends Sprite

var SPEED = 0.5 # in seconds

func kill():
	queue_free()
	get_parent().remove_child(self)

func _ready():
	get_node("Tween").interpolate_method(self, \
		"set_scale", \
		Vector2(1, 1), Vector2(0, 0), \
		SPEED, Tween.TRANS_CIRC, Tween.EASE_IN)
	get_node("Tween").interpolate_method(self, \
		"set_pos", \
		get_pos(), get_pos() - Vector2(0, 32), \
		SPEED, Tween.TRANS_CIRC, Tween.EASE_OUT)
	get_node("Tween").interpolate_method(self, \
		"set_modulate", \
		Color(1, 1, 1), Color(1, 1, 1, 0.5), \
		SPEED, Tween.TRANS_CIRC, Tween.EASE_OUT)
	get_node("Tween").start()

func _on_tween_complete(object, key):
	kill()