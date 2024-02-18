extends StaticBody2D

@onready var animator := $AnimatedSprite2D
@onready var health := $Health
@onready var spawner := $Spawner

func _ready():
	animator.play("Idle")

func _process(delta):
	if !animator.is_playing():
		health.hit = false
	
	if !health.dead:
		if health.hit:
			animator.play("Hit")
		else:
			animator.play("Idle")
	
	if health.dead and !health.used:
		animator.play("Cut")
		spawner.Spawn()
		health.used = true
	

		
