extends CanvasLayer

func set_text(t):
	get_node("Node2D").text = t

func _on_timer_timeout():
	queue_free()
	get_parent().remove_child(self)