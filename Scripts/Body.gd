extends Area2D

func _ready():
	set_fixed_process(true)

func _on_body_enter(body):
	if(body.is_in_group("items")):
		print("item")
		body.kill()
		get_node("../HUD/Inventory").add_item(body) # yeah this seems kinda stupid but it works so