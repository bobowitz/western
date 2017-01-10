extends Area2D

var sprite
var sprite_pos = Vector2(0, 0)

func _ready():
	set_process(true)

func _process(delta):
	if(sprite_pos != Vector2(0, 0)):
		sprite_pos.y -= delta * 20
		sprite.set_pos(sprite_pos)

func _on_body_enter(body):
	if(body.is_in_group("player")):
		body.get_node("PlayerControl").freeze()
		body.set_hidden(true)
		sprite = Sprite.new()
		sprite_pos = body.get_pos() - get_parent().get_pos()
		sprite.set_pos(sprite_pos)
		sprite.set_z(5)
		sprite.set_texture(body.get_node("Sprite").get_texture())
		sprite.set_centered(false)
		sprite.set_vframes(body.get_node("Sprite").get_vframes())
		sprite.set_hframes(body.get_node("Sprite").get_hframes())
		sprite.add_child(preload("res://Scenes/Animation.tscn").instance())
		sprite.get_node("Animation").add_animation("walk n", range(32, 40), 15, true)
		sprite.get_node("Animation").play("walk n")
		get_parent().add_child(sprite)