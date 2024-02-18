extends CharacterBody2D

@onready var Sight:Area2D = $Sight
@onready var FlipTimer:Timer = $FlipTimer
@onready var AttackTimer:Timer = $AttackTimer
@onready var Attack:Area2D = $Attack
@onready var animator:AnimatedSprite2D = $AnimatedSprite2D
@onready var health = $Health

@export var hit_distance:int = 20
var attack_dir = 0

enum State {Idle, MoveTo, MoveFrom, Hover, Attack}
var current_state: State = State.Idle

var speed = 100

var move_to = 200
var move_from = 150

var target

var flip = false
var attack = false

var attacking = false

func _ready():
	move_from = randi_range(100,150)
	move_to = move_from + randi_range(50,100)
	print("Move to : ", move_to)
	print("Move from : ", move_from)

func _process(_delta):
	if !target:
		current_state = State.Idle
	
	if Sight.objects_inside.size() > 0:
		if !target:
			target = Sight.objects_inside[0]
		
		if health.last_attacked:
			if Sight.objects_inside.has(health.last_attacked):
				target = health.last_attacked
				health.last_attacked = null
	else:
		target = null
		current_state = State.Idle
	
	var direction = Vector2.ZERO
	var distance = 0
	if target:
		distance = target.global_position.distance_to(global_position)
		direction = (target.global_position - global_position).normalized()
		
		if direction.x < 0:
			animator.flip_h = true
		else:
			animator.flip_h = false
		
		if !attack:
			if distance > move_to: # to enemy
				current_state = State.MoveTo
				
			if distance < move_from: # from enemy
				current_state = State.MoveFrom
				
			if move_to > distance and distance > move_from:
				current_state = State.Hover
			
	match current_state:
		State.Idle:
			animator.play("Idle")
			velocity = Vector2.ZERO
		State.MoveTo:
			animator.play("Walk")
			velocity = direction * speed
		State.MoveFrom:
			animator.play("Walk")
			velocity = -direction * speed
		State.Hover:
			animator.play("Walk")
			if FlipTimer.is_stopped():
				FlipTimer.start(randi_range(3,6))
			
			if AttackTimer.is_stopped():
				if !attack:
					AttackTimer.start(randi_range(5,10))
				
			if flip:
				velocity = Vector2(-direction.y, direction.x) * speed
			else:
				velocity = -Vector2(-direction.y, direction.x) * speed
		State.Attack:
			# Move in range
			if Attack.objects_inside.size() <= 0:
				if !attacking:
					animator.play("Walk")
					velocity = direction * speed
			
			if abs(direction.x) > abs(direction.y):
				attack_dir = 0
				if direction.x < 0:
					animator.flip_h = true
					Attack.global_position = global_position + Vector2(-1,0) * hit_distance
					Attack.look_at(global_position)
				else:
					animator.flip_h = false
					Attack.global_position = global_position + Vector2(1,0) * hit_distance
					Attack.look_at(global_position)
			else:
				if direction.y < 0:
					attack_dir = 1
					Attack.global_position = global_position + Vector2(0,-1) * hit_distance
					Attack.look_at(global_position)
				else:
					attack_dir = 2
					Attack.global_position = global_position + Vector2(0,1) * hit_distance
					Attack.look_at(global_position)
			
			# make attack or two
			if Attack.objects_inside.size() > 0:
				
				if !attacking:
					attacking = true
					# Attack Animation
					match attack_dir:
						0: # left right
							animator.play("Attack")
						1: # up
							animator.play("Attack_Up")
						2: # down
							animator.play("Attack_Down")

					if AttackTimer.is_stopped():
						print("AttackTimer is Staped")
						AttackTimer.start(randi_range(1,3))
					#_on_attack_timer_timeout()
	
	if !animator.is_playing():
		attacking = false
		Attack.Attack()
	
	move_and_slide()
	
func _on_flip_timer_timeout():
	flip = !flip

func _on_attack_timer_timeout():
	if !attack:
		print("Attacking")
		attack = true
		current_state = State.Attack
	else:
		print("Idle")
		current_state = State.Idle
		attack = false
		attacking = false
