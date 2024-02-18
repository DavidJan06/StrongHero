extends Node2D

@onready var animator:AnimatedSprite2D = $AnimatedSprite2D
@onready var timer:Timer = $Timer

func _ready():
	animator.play("Spawn")
	
func _on_animated_sprite_2d_animation_finished():
	if animator.animation == "Spawn":
		animator.play("Idle")
		timer.start(10)
	if animator.animation == "Despawn":
		queue_free()

func _on_timer_timeout():
	animator.play("Despawn")
