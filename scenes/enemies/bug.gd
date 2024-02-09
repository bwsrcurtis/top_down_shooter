extends CharacterBody2D

var hit_sound: AudioStreamPlayer2D

var player_nearby: bool = false
var player_in_range: bool = false
var can_attack : bool = true
var vulnerable: bool = true
var speed:int = 5
var health:int = 15


func _process(_delta):
	if player_nearby and not player_in_range:
		look_at(Globals.player_pos)
		velocity = global_position.direction_to(Globals.player_pos)
		global_position += velocity * speed
	elif player_in_range and can_attack:
		Globals.health -= 5
		can_attack = false
		$Timers/AttackCooldown.start()
	else: $AnimatedSprite2D.play("attack")

func _on_notice_area_body_entered(_body):
	player_nearby = true
	$AnimatedSprite2D.play("walk")

func _on_notice_area_body_exited(_body):
	player_nearby = false

func _on_attack_area_body_entered(_body):
	player_in_range = true
	$AnimatedSprite2D.play("attack")

func _on_attack_area_body_exited(_body):
	player_in_range = false
	
func _on_hit_cooldown_timeout():
	vulnerable = true
	$AnimatedSprite2D.material.set_shader_parameter("line_color", Plane(1,.32,.29,0))
	$Particles/HitParticles.emitting = false

func _on_attack_cooldown_timeout():
	can_attack = true

func hit():
	if vulnerable:
		hit_sound.play()
		health -= 10
		vulnerable = false
		$Timers/HitCooldown.start()
		$AnimatedSprite2D.material.set_shader_parameter("line_color", Plane(1,.32,.29,.5))
		$Particles/HitParticles.emitting = true
	if health <= 0:
		await get_tree().create_timer(.27).timeout
		queue_free()

func _ready():
	hit_sound = AudioStreamPlayer2D.new()
	hit_sound.stream = load("res://audio/organic_impact.mp3")
	add_child(hit_sound)

