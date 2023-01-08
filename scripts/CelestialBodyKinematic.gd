extends KinematicBody2D

var bodyName
var radius = pow(10, 1)
var color = Color.deeppink

var mass
var velocity = Vector2(0,0)
var mode

func _draw():
	draw_circle(Vector2(0, 0), radius, color)

func set_mass(mass):
	self.mass = mass

func set_mode(mode):
	self.mode = mode
	pass # irrelevant