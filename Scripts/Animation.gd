extends Node

# Animator: stack-based animation implementation
#
# Add animations to the Animator with add_animation.
# For looping animations, play() simply begins the animation and plays it
# forever.
# For non-looping animations, play() pushes the animation on top of the
# current animation. When it finishes, it is popped.

signal animation_finished

var __animations = {} # dictionary of all existing animations
var __stack = [] # stack of playing animations, 0th index is 'top'
				 # this contains names, which are Strings
var __start_time = 0 # when was the animation started
var __nl_overridable = false # if this is false, you cannot add a looping
							 # animation on top of a non-looping one
var __done = false # for non-looping animations: is it done

func add_animation(name, frames, fps, looping, flipped=false):
	__animations[name] = Animation.new(frames, fps, looping, flipped)

func set_non_looping_overridable(nl_overridable):
	__nl_overridable = nl_overridable

func __current_overridable_by(name):
	if(__animations[name].get_looping() and not __stack.empty() \
	and not __animations[__stack[0]].get_looping() and not __done):
		return false
	return true

func play_force(name):
	__stack.clear()
	__stack.push_front(name)
	__start_time = OS.get_ticks_msec()
	__done = false

func play(name):
	if(not __stack.empty() and __stack[0] == name):
		return
	
	if(__current_overridable_by(name)):
		if(__animations[name].get_looping()):
			__stack.clear()
		__stack.push_front(name)
		__start_time = OS.get_ticks_msec()
		__done = false

func _ready():
	set_process(true)

func _process(delta):
	if(__stack.empty()):
		return
	
	var m_fps = __animations[__stack[0]].get_fps() / 1000.0
	var frameIndex = int(m_fps * (OS.get_ticks_msec() - __start_time))
	if(frameIndex >= __animations[__stack[0]].get_frames().size()):
		if(__animations[__stack[0]].get_looping()):
			frameIndex %= __animations[__stack[0]].get_frames().size()
		else:
			if(__stack.size() > 1):
				__stack.pop_front()
				frameIndex = 0
			else:
				if(not __done):
					__done = true
					emit_signal("animation_finished")
				frameIndex = __animations[__stack[0]].get_frames().size() - 1
	var frame = __animations[__stack[0]].get_frames()[frameIndex]
	get_parent().set_frame(frame)
	get_parent().set_flip_h(__animations[__stack[0]].get_flipped())

class Animation:
	var __frames
	var __looping
	var __fps
	var __flipped
	
	func _init(frames, fps, looping, flipped):
		__frames = frames
		__looping = looping
		__fps = fps
		__flipped = flipped
	
	func get_frames():
		return __frames
	func set_frames(frames):
		__frames = frames
	func get_looping():
		return __looping
	func set_looping(looping):
		__looping = looping
	func get_fps():
		return __fps
	func set_fps(fps):
		__fps = fps
	func get_flipped():
		return __flipped
	func set_flipped(flipped):
		__flipped = flipped