extends Node2D

var celestialBodyScene = preload("res://scenes/CelestialBody.tscn");

var celestialBodies = {}

func _ready():	
	addSun()
	addPlanet('earth')

func addSun():
	var sun = celestialBodyScene.instance()
	sun.set_mode(1)
	# todo sprite

	add_child(sun)
	celestialBodies['sun'] = sun

func addPlanet(name):
	#var planet = celestialBodyScene.instance()

	pass

