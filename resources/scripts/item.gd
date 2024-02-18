extends Area2D

@export_enum("Meat", "Wood", "Gold") var item:String

@onready var Invetory = get_tree().current_scene.get_node("%Inventory")
@onready var animator = $AnimatedSprite2D

func _ready():
	match item:
		"Meat":
			animator.play("M_Spawn")
		"Wood":
			animator.play("W_Spawn")
		"Gold":
			animator.play("G_Spawn")

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if !Invetory.held_item:
				Invetory.held_item = self
			else:
				Invetory.held_item = null
			print("Item clicked")

func _process(_delta):
	if Invetory.held_item == self:
		global_position = get_global_mouse_position()
		
	if !animator.is_playing():
		match item:
			"Meat":
				animator.play("M_Idle")
			"Wood":
				animator.play("W_Idle")
			"Gold":
				animator.play("G_Idle")

func effect():
	match item:
		"Meat": # heal
			print("Heal +10")
			var player_health = get_tree().current_scene.get_node("Player").get_node("Health")
			player_health.heal(10)
			queue_free()
		"Wood": # Build
			print("Build")
		"Gold": # Tresury
			print("Money")
