extends Node2D

const celestialBodyScene = preload("res://scenes/CelestialBody.tscn");
const dataPath = "res://data/solar-system.csv"

var bodies = {}

func _ready():
	var data = loadData()
	initBodies(data)	

func loadData():
	var file = File.new()	
	file.open(dataPath, file.READ)
	var data = {}
	var header = file.get_csv_line(';')
	var types = file.get_csv_line(';')
	while !file.eof_reached():
		var row = file.get_csv_line(';')
		if(row.size() > 1):
			var name = row[0]
			data[name] = {}
			for i in range(1, header.size()):				
				var value
				match types[i]:
					'string':
						value = row[i]
					'float':
						value = float(row[i])
					'int':
						value = int(row[i])
				data[name][header[i]] = value

	return data

func initBodies(data):
	for name in data:	
		var body = createBody(data[name])
		bodies[name] = body
		add_child(body)

func createBody(data):
	var body = celestialBodyScene.instance()		
	body.set_mode(data['mode'])
	body.color = Color(data['color'])
	body.set_position(Vector2(data['DistanceToSun[Mkm]'], 0))
	body.get_node('Sprite')
	return body
