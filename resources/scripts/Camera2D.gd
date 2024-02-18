extends Camera2D

var speed = 5

func _process(_delta):
	# We create a local variable to store the input direction.
	var direction = Vector2.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		
	if Input.is_action_just_released("Mouse_Scroll_Up"):
		zoom += Vector2(0.1,0.1)
	if Input.is_action_just_released("Mouse_Scroll_Down"):
		if zoom > Vector2(0.1,0.1):
			zoom -= Vector2(0.1,0.1)
	
	if zoom < Vector2(0.1,0.1):
		zoom = Vector2(0.1,0.1)
		
	position += direction * speed
