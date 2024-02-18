extends Control

var item1
var item2

var held_item

func _on_panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if held_item and !item1:
				var point = %ItemPoint1
				item1 = held_item
				held_item = null
				item1.reparent(point)
				item1.global_position = point.global_position
			else:
				if item1:
					held_item = item1
					item1 = null
					held_item.reparent(get_tree().current_scene.get_node("%Items"))

func _on_panel_2_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if held_item and !item2:
				var point = %ItemPoint2
				item2 = held_item
				held_item = null
				item2.reparent(point)
				item2.global_position = point.global_position
			else:
				if item2:
					held_item = item2
					item2 = null
					held_item.reparent(get_tree().current_scene.get_node("%Items"))
			
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("Use_Item1") and item1:
			item1.effect()
		if event.is_action_pressed("Use_Item2") and item2:
			item2.effect()
