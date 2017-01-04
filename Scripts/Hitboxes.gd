extends Node

var saloon
var saloon_bullet

func _ready():
	saloon = preload("res://Scenes/Hitboxes/Saloon.tscn")
	saloon_bullet = preload("res://Scenes/Hitboxes/SaloonBullet.tscn")