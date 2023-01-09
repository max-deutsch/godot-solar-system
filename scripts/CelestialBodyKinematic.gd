extends KinematicBody2D

var bodyName
var radius = pow(10, 1)
var color = Color.deeppink

var mass
var velocity = Vector2(0,0)
var mode

var last_pos
var roundStartTimeMs
var roundTimesMs = []

func _ready():
	roundStartTimeMs = OS.get_system_time_msecs()

func _draw():
	draw_circle(Vector2(0, 0), radius, color)

func set_mass(mass):
	self.mass = mass

func set_mode(mode):
	self.mode = mode
	pass # irrelevant

func _process(delta):
	if self.last_pos.y > 0.0 and 0.0 > self.position.y:
		var roundTimeMs = OS.get_system_time_msecs() - roundStartTimeMs
		self.roundTimesMs.append(roundTimeMs)
		self.roundStartTimeMs = OS.get_system_time_msecs()
#		print("%s round time: %d [ms]" % [bodyName, roundTimeMs])	
	
	self.last_pos = self.position
