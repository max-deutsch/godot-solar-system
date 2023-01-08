extends RigidBody2D

var bodyName
var radius = 10
var color = Color.deeppink

func _ready():
	pass # Replace with function body.


func _draw():
	draw_circle(Vector2(0, 0), radius, color)
	
