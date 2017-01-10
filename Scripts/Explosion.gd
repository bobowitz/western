extends Node2D

var EXPLOSIONS = 15
var RADIUS = 25
var done_count = 0

func _ready():
	for i in range(EXPLOSIONS):
		var s = Sprite.new()
		s.set_pos(Vector2(rand_range(-RADIUS, RADIUS), rand_range(-RADIUS, RADIUS)))
		s.set_texture(preload("res://Sprites/fxset.png"))
		s.set_vframes(15)
		s.set_hframes(20)
		s.add_child(preload("res://Scenes/Animation.tscn").instance())
		s.get_node("Animation").connect("animation_finished", self, "_on_animation_finished")
		var arr = []
		for x in range(i / 5):
			arr.push_back(-1)
		s.get_node("Animation").add_animation("pop", arr + range(20, 31), 25, false)
		s.get_node("Animation").play("pop")
		add_child(s)

func _on_animation_finished(anim):
	anim.get_parent().queue_free()
	anim.get_parent().get_parent().remove_child(anim.get_parent())
	done_count += 1
	if(done_count == EXPLOSIONS):
		queue_free()
		get_parent().remove_child(self)