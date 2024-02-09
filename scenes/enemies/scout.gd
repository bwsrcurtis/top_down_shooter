extends CharacterBody2D

var hit_sound: AudioStreamPlayer2D

var health: int = 25
var player_nearby: bool = false
var can_laser: bool = true
var gun_1: bool = true
var vulnerable: bool = true


signal laser(pos, direction)

func _process(_delta):
	if player_nearby:
		look_at(Globals.player_pos)
		if can_laser:
			var selected_laser = $LaserSpawnPositions.get_child(gun_1)
			gun_1 = not gun_1
			var pos = selected_laser.global_position
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			$Timers/LaserCooldown.start()


func _on_attack_area_body_entered(_body):
	player_nearby = true

func _on_attack_area_body_exited(_body):
	player_nearby = false

func _on_laser_cooldown_timeout():
	can_laser = true

func _on_hit_cooldown_timeout():
	vulnerable = true
	$Sprite2D.material.set_shader_parameter("line_color", Plane(1,.32,.29,0))
	$Particles/HitParticles.emitting = false
	
func hit():
	hit_sound.play()
	if vulnerable:
		health -= 10
		vulnerable = false
		$Timers/HitCooldown.start()
		$Sprite2D.material.set_shader_parameter("line_color", Plane(1,.32,.29,.5))
		$Particles/HitParticles.emitting = true
	if health <= 0:
		await get_tree().create_timer(.27).timeout
		queue_free()
	
func _ready():
	hit_sound = AudioStreamPlayer2D.new()
	hit_sound.stream = load("res://audio/organic_impact.mp3")
	add_child(hit_sound)

