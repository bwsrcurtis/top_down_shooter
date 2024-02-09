extends CharacterBody2D

var hit_sound: AudioStreamPlayer2D

var active: bool = false
var explosion_range: int = 400
@export var speed: int = 400
var max_speed: int = 2000
var vulnerable: bool = true
var health: int = 30
var exploding: bool = false

func _ready():
	exploding = false
	$Explosion.hide()
	$Sprite2D.show()
	hit_sound = AudioStreamPlayer2D.new()
	hit_sound.stream = load("res://audio/solid_impact.ogg")
	add_child(hit_sound)

func _process(delta):
	if active and not exploding:
		look_at(Globals.player_pos)
		
		# Increase speed as drone approaches player
		var tween = get_tree().create_tween()
		tween.tween_property(self, "speed", max_speed, 2).from_current()
		var direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed
		var collision = move_and_collide(velocity * delta)
		
		if collision:
			# Stop movement and activate explosion
			tween.kill()
			$AnimationPlayer.play('explosion')
			exploding = true
			# Determine hits
			for entity in get_tree().get_nodes_in_group("Entities") + get_tree().get_nodes_in_group("Container"):
					check_distance_and_hit(entity)
			
			
func _on_hit_timer_timeout():
	vulnerable = true
	$Sprite2D.material.set_shader_parameter("line_color", Plane(1,.32,.29,0))
	
func hit():
	if vulnerable:
		hit_sound.play()
		health -= 10
		vulnerable = false
		$HitTimer.start()
		$Sprite2D.material.set_shader_parameter("line_color", Plane(1,.32,.29,.5))
	if health <= 0:
		$AnimationPlayer.play('explosion')
		exploding = true


func _on_notice_area_body_entered(_body):
	active = true

func check_distance_and_hit(entity):
	if global_position.distance_to(entity.global_position) < explosion_range and "hit" in entity:
		entity.hit()


