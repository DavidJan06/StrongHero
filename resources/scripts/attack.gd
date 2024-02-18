extends Area2D

@export var Damage:int = 20

var objects_inside:Array

func Attack():
	print("I Attack")
	for object in objects_inside:
		object.get_node("Health").damage(Damage)
		if !object.is_in_group("Resource"):
			object.get_node("Health").last_attacked = get_parent()

func _on_body_entered(body):
	if body.has_node("Health"):
		objects_inside.append(body)

func _on_body_exited(body):
	if objects_inside.has(body):
		objects_inside.erase(body)

