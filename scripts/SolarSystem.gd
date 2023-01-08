extends Node2D

const celestialBodyScene = preload("res://scenes/CelestialBody.tscn");
const dataPath = "res://data/solar-system.csv"

var celestialBodies = {}

func _ready():
	loadData()
	print(celestialBodies)
	addSun()
	addPlanet('earth')

func loadData():
	var file = File.new()
	file.open(dataPath, file.READ)
	var header = file.get_csv_line(';')
	while !file.eof_reached():
		var row = file.get_csv_line(';')
		if(row.size() > 1):
			var name = row[0]
			celestialBodies[name] = {}
			for i in range(1, header.size()):
				celestialBodies[name][header[i]] = float(row[i])
		
func addSun():
	var sun = celestialBodyScene.instance()
	sun.set_mode(1)
	# todo sprite

	add_child(sun)
	celestialBodies['sun'] = sun

func addPlanet(name):
	#var planet = celestialBodyScene.instance()

	pass

