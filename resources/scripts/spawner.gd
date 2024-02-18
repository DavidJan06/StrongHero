extends Node2D

@export var Spawnable:Resource
@export var Parent :Node = self
@export var Number:int = 1

func Spawn():
	for n in range(0, Number):
		var inti = Spawnable.instantiate()
		inti.position = get_parent().position + Vector2(randi_range(-50,50), randi_range(-50,50))
		Parent.add_child(inti)
