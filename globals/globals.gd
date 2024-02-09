extends Node


var player_hit_sound: AudioStreamPlayer2D

signal laser_change
signal grenade_change
signal health_change

var laser_amount = 20:
	set(value):
		laser_amount = value
		laser_change.emit()

var grenade_amount = 5:
	set(value):
		grenade_amount = value
		grenade_change.emit()

var player_vulnerable: bool = true
var health = 100:
	set(value):
		if value > health:
			health = min(value, 100)
		else:
			if player_vulnerable:
				health = value
				player_vulnerable = false
				player_invulnerable_timer()
				player_hit_sound.play()
		health_change.emit()
func player_invulnerable_timer():
	await get_tree().create_timer(.5).timeout
	player_vulnerable = true

var player_pos: Vector2


func _ready():
	player_hit_sound = AudioStreamPlayer2D.new()
	player_hit_sound.stream = load("res://audio/solid_impact.ogg")
	add_child(player_hit_sound)
