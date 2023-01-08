extends Node2D

const celestialBodyScene = preload("res://scenes/CelestialBody.tscn");
const dataPath = "res://data/solar-system.csv"
const G = 100

var bodies = []
var sun

func _ready():
	print(G)
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
			for i in range(0, header.size()):				
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
		bodies.append(body)
		add_child(body)
		if body.bodyName == 'Sun':
			sun = body
	for body in bodies:
		setInitialVelocity(body)

func createBody(data):
	var body:RigidBody2D = celestialBodyScene.instance()
	body.bodyName = data['Name']
	body.color = Color(data['color'])
	body.set_mode(data['mode'])	
	body.set_mass(data['Mass[earths]'])
	body.set_position(-Vector2(data['DistanceToSun[Mkm]'], 0))
	return body

func setInitialVelocity(body):
	if body != sun:
		var pos1 = body.position
		var pos2 = sun.position
		var r = pos1.distance_to(pos2)
		var v = sqrt(G * sun.mass / r)
		body.set_linear_velocity(Vector2(0, -v))


func _physics_process(delta):
	for body in bodies:
		applyForces(body, delta)

func applyForces(body, delta):
	for other in bodies:
		if body != other:						
			var pos1 = body.position
			var pos2 = other.position
			var r2 = pos1.distance_squared_to(pos2)
			var force = G * body.mass * other.mass / r2			
			var dir = pos2.direction_to(pos1)
			var forceVector = dir * -force			
			body.add_central_force(forceVector)
