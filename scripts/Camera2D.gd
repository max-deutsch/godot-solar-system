extends Camera2D


var mouse_start_pos
var screen_start_position

var dragging = false


func _input(event):
	if event.is_action("reset_view"):
		zoom = Vector2(1,1)
		position = Vector2(0,0)
	elif event.is_action("zoom_in"):
		zoom -= Vector2(1, 1)
	elif event.is_action("zoom_out"):
		zoom += Vector2(1, 1)
	elif event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false		
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
