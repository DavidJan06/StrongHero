extends Node2D

@export var health:int = 100

@onready var Paricale:CPUParticles2D = $CPUParticles2D
@onready var healthbar = $TextureProgressBar

var Dead = preload("res://resources/scenes/dead.tscn")

var last_attacked

func damage(amount):
	health -= amount
	print("I am Hit")
	Paricale.emitting = true
	updateHealthBar()
	
	if health <= 0:
		print("I am Dead")
		var deadInstance = Dead.instantiate()
		get_tree().current_scene.get_node("Grave").add_child(deadInstance)
		deadInstance.global_position = global_position
		get_parent().queue_free()

func heal(amount):
	health += amount
	
	if health > 100:
		health == 100
		
	updateHealthBar()
	
func updateHealthBar():
	healthbar.value = health
	if healthbar.value <= 0 or healthbar.value >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
