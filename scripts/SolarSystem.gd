extends Node2D

const celestialBodyScene = preload("res://scenes/CelestialBody.tscn");
const celestialBodyKinematicScene = preload("res://scenes/CelestialBodyKinematic.tscn");
const dataPath = "res://data/solar-system.csv"
const G = 100

var bodies = []
var sun

var useKinematic = true

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
	
	if useKinematic:
		setInitialVelocitiesKinematic()
	else:
		for body in bodies:
			setInitialVelocity(body)

func createBody(data):
	var body
	if useKinematic:
		body = celestialBodyKinematicScene.instance()
	else:
		body = celestialBodyScene.instance()
	body.bodyName = data['Name']
	body.color = Color(data['color'])
	body.set_mode(data['mode'])
	body.set_mass(data['Mass[earths]'])
	body.set_position(Vector2(data['DistanceToSun[Mkm]'], 0))
	body.last_pos = body.position
	
	return body

func setInitialVelocity(body):
	var v = 0
	for other in bodies:
		if body != other:	
			var pos1 = body.position
			var pos2 = other.position
			var r = pos1.distance_to(pos2)
			v += sqrt(G * other.mass / r)
	body.set_linear_velocity(Vector2(0, -v))


func _physics_process(delta):
	if useKinematic:
		for body1 in bodies:
			for body2 in bodies:
				if body1 != body2:
					apply_newtonian_gravity(delta, body1, body2)
	else:
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

# # Kinematic Version
# Inspired by
# https://godotengine.org/qa/79496/how-do-you-make-the-player-jump-planet-with-realistic-gravity

var GRAVITY = 100

func setInitialVelocitiesKinematic():
	for body1 in bodies:
		var v = 0
		if body1.bodyName != 'Sun':
			for body2 in bodies:
				if body1 != body2:
					var pos1 = body1.global_transform.origin
					var pos2 = body2.global_transform.origin
					var r = pos1.distance_to(pos2)
					v += sqrt(GRAVITY * body2.mass / r)
			var SOME_FACTOR = 0.34
			body1.velocity = Vector2(0, -v) * SOME_FACTOR

func apply_newtonian_gravity(delta, body1, body2):
	var pos1 = body1.position
	var pos2 = body2.position
	var dir = pos1.direction_to(pos2)
	var r2 = pos1.distance_squared_to(pos2)
	body1.velocity += dir * G * body2.mass / r2 * delta	
	body1.move_and_slide(body1.velocity, Vector2.UP)
