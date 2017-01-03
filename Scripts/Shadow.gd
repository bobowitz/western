extends Sprite

# Shadow
#
# Dynamic shadows behind sprite
# Shadow heights are broken
# everything else works

var sprite_size

var __shadow_color = Color(0, 0, 0, 0.25)
var __shadow_scale = Vector2(1, 1)
var __sprite_height = 0
var __shear_mag = 1.0 / 2.0

func set_color(color):
	__shadow_color = color

func set_shadow_height(height):
	__shadow_scale.y = height

func set_sprite_height(height):
	__sprite_height = height

func set_shear_mag(shear):
	__shear_mag = shear

func _ready():
	# size should be (w + h/2, h/2)
	self.set_texture(get_parent().get_texture())
	self.set_vframes(get_parent().get_vframes())
	self.set_hframes(get_parent().get_hframes())
	self.set_frame(get_parent().get_frame())
	
	sprite_size = Vector2(get_texture().get_width() / get_hframes(), \
						  get_texture().get_height() / get_vframes())
	
	get_material().set_shader_param("tex_size", \
		get_parent().get_texture().get_size())
	get_material().set_shader_param("sprite_size", sprite_size)
	
	set_process(true)

func _process(delta):
	set_scale(__shadow_scale * Vector2(2 * max(1, __shear_mag) * \
			  sprite_size.y / sprite_size.x, 0.5))
	
	if(get_parent().is_flipped_h()): #3 * (-sprite_size.y * __shear_mag) + 1
		set_pos(Vector2(-2 * max(1, __shear_mag) * sprite_size.y \
				+ sprite_size.x + 1, \
				sprite_size.y - __shadow_scale.y * sprite_size.y * 0.5))
	else:
		set_pos(Vector2(-sprite_size.y * __shear_mag - 1, \
				sprite_size.y - __shadow_scale.y * sprite_size.y * 0.5))
	get_material().set_shader_param("shadow_color", __shadow_color)
	get_material().set_shader_param("sprite_pos", \
		Vector2( \
			(get_parent().get_frame() % get_hframes()) * sprite_size.x, \
			(get_parent().get_frame() / get_hframes()) * sprite_size.y))
	get_material().set_shader_param("shear_mag", __shear_mag)
	get_material().set_shader_param("flipped", get_parent().is_flipped_h())
	set_flip_h(get_parent().is_flipped_h())