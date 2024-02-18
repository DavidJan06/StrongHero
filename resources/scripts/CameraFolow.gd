extends Camera2D

@export var player:CharacterBody2D

var smoothing =  0.1

func _process(_delta):
	if !player:
		return
	
	global_position = global_position.lerp(player.global_position, smoothing)

	if Input.is_action_just_released("Mouse_Scroll_Up"):
		zoom += Vector2(0.1,0.1)
	if Input.is_action_just_released("Mouse_Scroll_Down"):
		if zoom > Vector2(0.1,0.1):
			zoom -= Vector2(0.1,0.1)
	
	if zoom < Vector2(0.1,0.1):
		zoom = Vector2(0.1,0.1)
