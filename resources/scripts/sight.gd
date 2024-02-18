extends Area2D

var objects_inside:Array

@export var group:String

func _on_body_entered(body):
	if body.is_in_group(group):
		objects_inside.append(body)

func _on_body_exited(body):
	if objects_inside.has(body):
		objects_inside.erase(body)
