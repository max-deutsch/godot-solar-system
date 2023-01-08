extends RigidBody2D

var bodyName
var radius = pow(10, 1)
var color = Color.deeppink

func _ready():
	pass # Replace with function body.


func _draw():
	draw_circle(Vector2(0, 0), radius, color)
	
