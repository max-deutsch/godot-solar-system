extends Camera2D


var mouse_start_pos
var screen_start_position

var dragging = false

signal zoom_changed(value)

func _ready():
	init()

func init():
	zoom = Vector2(1, 1) * 5
	position = Vector2(0, 0)


func _input(event):
	if event.is_action("ui_down"):
		Engine.time_scale = max(Engine.time_scale - 0.1, 0.0)
	elif event.is_action("ui_up"):
		Engine.time_scale += 0.1
	elif event.is_action("reset_view"):
		init()
	elif event.is_action("zoom_in"):
		zoom -= Vector2(1, 1)
		emit_signal("zoom_changed", zoom)
	elif event.is_action("zoom_out"):
		zoom += Vector2(1, 1)
		emit_signal("zoom_changed", zoom)
	elif event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false		
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
