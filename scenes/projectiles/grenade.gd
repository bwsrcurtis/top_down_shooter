extends RigidBody2D

var grenade_range: int = 400
var speed = 750
@export var exploding: bool = false

func explode():
	$AnimationPlayer.play("Explosion")
	
	for entity in get_tree().get_nodes_in_group("Entities") + get_tree().get_nodes_in_group("Container"):
		check_distance_and_hit(entity)
			

func check_distance_and_hit(entity):
	if global_position.distance_to(entity.global_position) < grenade_range:
		entity.hit()
