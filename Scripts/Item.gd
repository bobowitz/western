extends StaticBody2D

var ID = ItemConstants.CRATE
var kill_anim

func kill():
	var k = kill_anim.instance()
	k.set_texture(get_node("Sprite").get_texture())
	k.set_vframes(get_node("Sprite").get_vframes())
	k.set_hframes(get_node("Sprite").get_hframes())
	k.set_frame(get_node("Sprite").get_frame())
	k.set_pos(get_pos())
	get_parent().add_child(k)
	queue_free()
	get_parent().remove_child(self)

func _ready():
	kill_anim = preload("res://Scenes/ItemKill.tscn")