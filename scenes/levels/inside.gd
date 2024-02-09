extends LevelParent

#var outside_level_scene: PackedScene = preload("res://scenes/levels/outside.tscn")

func _on_exit_gate_area_body_entered(_body):
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, .5)
	#get_tree().change_scene_to_file.bind("res://scenes/levels/outside.tscn").call_deferred()
	#get_tree().change_scene_to_packed.bind(outside_level_scene).call_deferred()
	TransitionLayer.change_scene("res://scenes/levels/outside.tscn")
