extends CharacterBody2D

var can_laser: bool = true
var can_grenade: bool = true

signal laser(pos, direction)
signal grenade(pos, direction)

@export var max_speed: int = 1000
var speed: int = max_speed


func hit():
	Globals.health -= 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	
	# rotate
	look_at(get_global_mouse_position())
	
	 #laser shooting input
	if Input.is_action_pressed("primary action") && can_laser and Globals.laser_amount > 0:
		# randomly select a marker2d for the laser start
		Globals.laser_amount -= 1
		can_laser = false
		$ShootTimer.start()
		$LaserParticles.emitting = true
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		var pos = selected_laser.global_position
		var player_direction = (get_global_mouse_position() - position).normalized()
		laser.emit(pos, player_direction)
		
	
	if Input.is_action_pressed("secondary action") && can_grenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		can_grenade = false
		$GrenadeTimer.start()
		var pos = $GrenadeStartPosition.global_position
		var player_direction = (get_global_mouse_position() - position).normalized()
		grenade.emit(pos, player_direction)


func _on_shoot_timer_timeout():
	can_laser = true


func _on_grenade_timer_timeout():
	can_grenade = true
	
