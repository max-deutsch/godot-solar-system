extends Camera2D


var mouse_start_pos
var screen_start_position

var dragging = false


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 4:
			zoom -= Vector2(1, 1)
		elif event.button_index == 5:
			zoom += Vector2(1, 1)

		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
		
		
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
