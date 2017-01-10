extends Node

var _damage = 1
var _ammo_per_shot = 1
var _fire_rate = 0.5
var _health = 11
var _movement_speed = 150.0
var _hold_to_shoot = false
var _fire = false
var _explosion = false
var _clone = false
var _pass_through = false
var _sticky_bullets = false
var _knockback = 4
var _luck = 1

func copy_stats(stats):
	_damage = stats._damage
	_ammo_per_shot = stats._ammo_per_shot
	_fire_rate = stats._fire_rate
	_knockback = stats._knockback
	_health = stats._health
	_movement_speed = stats._movement_speed
	_fire = stats._fire
	_explosion = stats._explosion
	_clone = stats._clone
	_pass_through = stats._pass_through
	_sticky_bullets = stats._sticky_bullets
	_hold_to_shoot = stats._hold_to_shoot
	_luck = stats._luck

func set_stats(damage, ammo_per_shot, fire_rate, knockback, health, movement_speed, fire, explosion, clone, pass_through, sticky_bullets, hold_to_shoot, luck):
	_damage = floor(damage)
	_ammo_per_shot = floor(ammo_per_shot)
	_fire_rate = fire_rate
	_knockback = floor(knockback)
	_health = floor(health)
	_movement_speed = floor(movement_speed)
	_fire = fire
	_explosion = explosion
	_clone = clone
	_pass_through = pass_through
	_sticky_bullets = sticky_bullets
	_hold_to_shoot = hold_to_shoot
	_luck = luck
	if(has_node("../../Weapon")):
		update_stats()

func update_stats():
	# set fire rate
	get_node("../WeaponControl/FireRateTimer").set_wait_time(_fire_rate)
	
	# set health
	var hp_deficit = get_node("../../Health").get_full_hp() - get_node("../../Health").get_hp()
	get_node("../../Health").set_full_hp(_health)
	get_node("../../Health").set_hp(_health - hp_deficit)
	
	# set movement speed
	get_node("../../PlayerControl").set_speed(_movement_speed)

func description_string():
	var desc = ""
	desc += "damage: " + "%d" % _damage + "\n"
	desc += "ammo per shot: " + "%d" % _ammo_per_shot + "\n"
	desc += "fire rate: " + "%.1f" % (1/_fire_rate) + " bullets/s\n"
	desc += "health: " + "%d" % _health + "\n"
	desc += "movement speed: " + "%d%%" % (100*(_movement_speed / 150.0)) + "\n"
	return desc

func _ready():
	update_stats()