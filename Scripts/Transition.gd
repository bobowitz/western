extends CanvasLayer

# 16x16 tiles

signal transition_start
signal transition_dark
signal transition_fade_in
signal transition_done

var tex
var tile_size = Vector2(32, 32)
var sprites = []
var start_time = 0 # msecs
var FADE_OUT_TIME = 500.0 # msecs
var FADE_IN_TIME = 500.0 # msecs
var DARK_TIME = 1000.0 # msecs
var overlap = 1 # how many frames before next cascade triggers
var frames_per_tile = 15
var total_frames = 0
var playing = false

func start():
	if(playing):
		print("TRANSITION ALREADY PLAYING!")
		return
	emit_signal("transition_start")
	playing = true
	for sprite in sprites:
		add_child(sprite)
	start_time = OS.get_ticks_msec()

func _ready():
	connect("transition_dark", get_parent(), "_on_transition_dark")
	connect("transition_fade_in", get_parent(), "_on_transition_fade_in")
	
	tex = preload("res://Sprites/transition_tileset.png")
	for x in range(0, WorldConstants.ROOM_SIZE.x, tile_size.x):
		for y in range(0, WorldConstants.ROOM_SIZE.y, tile_size.y):
			var sprite = Sprite.new()
			sprite.set_centered(false)
			sprite.set_texture(tex)
			sprite.set_pos(Vector2(x, y))
			sprite.set_hframes(frames_per_tile)
			sprite.set_z(5)
			sprites.push_back(sprite)
	total_frames = frames_per_tile + 1
	set_process(true)

var last_frame_fade_out = false
var last_frame_dark = false
func _process(delta):
	if(playing):
		var frame
		if(OS.get_ticks_msec() - start_time < FADE_OUT_TIME):
			frame = total_frames * ((OS.get_ticks_msec() - start_time) / FADE_OUT_TIME)
			last_frame_fade_out = true
		elif(OS.get_ticks_msec() - start_time < FADE_OUT_TIME + DARK_TIME):
			if(last_frame_fade_out):
				emit_signal("transition_dark")
				last_frame_fade_out = false
			frame = total_frames - 1
			last_frame_dark = true
		elif(OS.get_ticks_msec() - start_time < FADE_OUT_TIME + DARK_TIME + FADE_IN_TIME):
			if(last_frame_dark):
				emit_signal("transition_fade_in")
				last_frame_dark = false
			frame = (total_frames) * (1.0 - ((OS.get_ticks_msec() - start_time - (DARK_TIME + FADE_OUT_TIME)) / FADE_IN_TIME)) - 1
		else:
			emit_signal("transition_done")
			playing = false
			for sprite in sprites:
				remove_child(sprite)
			return
		for sprite in sprites:
			sprite.set_hidden(frame < 1)
			sprite.set_frame(max(0, frame - 1))