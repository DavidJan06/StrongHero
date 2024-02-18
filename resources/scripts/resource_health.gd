extends Node2D

@export var health:int = 100

@onready var Paricale:CPUParticles2D = $CPUParticles2D
@onready var healthbar := $TextureProgressBar
@onready var timer := $Timer

var dead = false
var used = false
var hit = false

func damage(amount):
	health -= amount
	print("I am Hit")
	Paricale.emitting = true
	hit = true
	updateHealthBar()
	
	if health <= 0:
		print("I am Dead")
		dead = true
		if timer.is_stopped():
			timer.start(randi_range(20,60))

func heal(amount):
	health += amount
	
	if health > 100:
		health == 100
		
	updateHealthBar()
	
func updateHealthBar():
	healthbar.value = health
	if healthbar.value <= 0 or healthbar.value == 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_timer_timeout():
	dead = false
	used = false
	health = 100
	updateHealthBar()
