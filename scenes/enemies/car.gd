extends PathFollow2D

var player_near: bool = false
var health: int = 10

@onready var line1: Line2D = $Turret/RayCast2D/Line2D
@onready var line2: Line2D = $Turret/RayCast2D2/Line2D2

func fire():
	Globals.health -= 20

func _ready():
	line1.add_point($Turret/RayCast2D.target_position)
	line2.add_point($Turret/RayCast2D2.target_position)
	$Turret/RayCast2D/FireSprite.visible = false
	$Turret/RayCast2D2/FireSprite2.visible = false

func _process(delta):
	progress_ratio += .005 * delta
	if player_near:
		$Turret.look_at(Globals.player_pos)



func _on_notice_area_body_entered(_body):
	player_near = true
	$AnimationPlayer.play('laser_load')


func _on_notice_area_body_exited(_body):
	player_near = false
	$AnimationPlayer.pause()
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(line1, "width", 0, randf_range(0.1,.5))
	tween.tween_property(line2, "width", 0, randf_range(0.1,.5))
	await tween.finished
	$AnimationPlayer.stop()
	$Turret/RayCast2D/FireSprite.visible = false
	$Turret/RayCast2D2/FireSprite2.visible = false

func hit():
	health -= 10
	if health <= 0:
		queue_free()
