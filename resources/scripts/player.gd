extends CharacterBody2D

# Player speed
var speed =  200

@export var hit_distance:int = 20

@onready var animator:AnimatedSprite2D = $AnimatedSprite2D
@onready var attack = $Attack

var playerZLevel = 1

var attacking = false
var attack_num = 1
var attack_dir = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	if !attacking:
		direction.x = Input.get_axis("ui_left", "ui_right")
		direction.y = Input.get_axis("ui_up", "ui_down")
	
		if direction != Vector2.ZERO:
			animator.play("Walk")
		else:
			animator.play("Idle")
		
		if Input.is_action_pressed("ui_left") :
			animator.flip_h = true
		if Input.is_action_pressed("ui_right") :
			animator.flip_h = false
	
	var mouse_pos = get_mouse_position()
	
	
	#print(mouse_pos)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if abs(mouse_pos.x) > abs(mouse_pos.y):
			# its x
			attack_dir = 0
			if mouse_pos.x < 0:
				animator.flip_h = true
				attack.global_position = global_position + Vector2(-1,0) * hit_distance
				attack.look_at(global_position)
			else:
				animator.flip_h = false
				attack.global_position = global_position + Vector2(1,0) * hit_distance
				attack.look_at(global_position)
		else:
			# its y
			if mouse_pos.y < 0:
				attack_dir = 1
				attack.global_position = global_position + Vector2(0,-1) * hit_distance
				attack.look_at(global_position)
			else:
				attack_dir = 2
				attack.global_position = global_position + Vector2(0,1) * hit_distance
				attack.look_at(global_position)
				
		
		
		if !attacking:
			attack.Attack()
			attacking = true
			match attack_dir:
				0: # left right
					if attack_num == 1:
						animator.play("Attack_Downer")
						attack_num = 2
					elif attack_num == 2:
						animator.play("Attack_Upper")
						attack_num = 1
				1: # up
					if attack_num == 1:
						animator.play("Attack_Downer_Up")
						attack_num = 2
					elif attack_num == 2:
						animator.play("Attack_Upper_Up")
						attack_num = 1
				2: # down
					if attack_num == 1:
						animator.play("Attack_Downer_Down")
						attack_num = 2
					elif attack_num == 2:
						animator.play("Attack_Upper_Down")
						attack_num = 1
			
	if !animator.is_playing():
		attacking = false
		
	velocity = direction * speed
	move_and_slide()

func get_mouse_position():
	var mouse_position = get_viewport().get_mouse_position()
	var screen_center = get_viewport().size /  2
	var direction_to_mouse = (mouse_position - Vector2(screen_center)).normalized()
	return direction_to_mouse
