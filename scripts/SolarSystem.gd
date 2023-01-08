extends Node2D

const celestialBodyScene = preload("res://scenes/CelestialBody.tscn");
const dataPath = "res://data/solar-system.csv"

var bodies = {}

func _ready():
	var data = loadData()
	addBodies(data)
	

func loadData():
	var file = File.new()	
	file.open(dataPath, file.READ)
	var data = {}
	var header = file.get_csv_line(';')
	while !file.eof_reached():
		var row = file.get_csv_line(';')
		if(row.size() > 1):
			var name = row[0]
			data[name] = {}
			for i in range(1, header.size()):
				data[name][header[i]] = float(row[i])
	return data

func addBodies(data):
	for name in data:
		var body = celestialBodyScene.instance()		
		body.set_mode(int(data[name]['static']))

		bodies[body['name']] = body
		add_child(body)
