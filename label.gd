extends Label

@export var player: Node3D

var show_coords = false

func _process(_delta):
	if Input.is_key_pressed(KEY_F3):
		show_coords = true
	else:
		show_coords = false

	visible = show_coords

	if show_coords and player:
		var pos = player.global_position
		text = "X: " + str(pos.x) + "\nY: " + str(pos.y) + "\nZ: " + str(pos.z)
