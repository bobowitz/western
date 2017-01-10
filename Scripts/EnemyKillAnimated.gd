extends Sprite

func kill():
	queue_free()
	get_parent().remove_child(self)

func _ready():
	get_node("Animation").connect("animation_finished", self, "_on_animation_finished")
	
	get_node("Animation").add_animation("die", range(224, 232), 15, false)
	get_node("Animation").play("die")

func _on_animation_finished(anim):
	kill()