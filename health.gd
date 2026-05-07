extends ProgressBar

@export var player: CharacterBody3D

func _process(_delta):
	if player:
		max_value = player.max_health
		value = player.health
