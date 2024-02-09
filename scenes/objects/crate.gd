extends ItemContainer


var hit_sound: AudioStreamPlayer2D

func hit():
	hit_sound.play()
	if not opened:
		$LidSprite.hide()
		for i in range(5):
			var pos = $SpawnPositions.get_child(randi()%$SpawnPositions.get_child_count()).global_position
			open.emit(pos, current_direction)
		opened = true

func _ready():
	hit_sound = AudioStreamPlayer2D.new()
	hit_sound.stream = load("res://audio/container_hit.mp3")
	add_child(hit_sound)
