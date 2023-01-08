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
		for obj_1 in bodies:
			for obj_2 in bodies:
				if obj_1 != obj_2:
					newtonian_gravity(delta, obj_1, obj_2)
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

# # Kinematic


var GRAVITY = 100

func setInitialVelocitiesKinematic():
	for body1 in bodies:
		var v = 0
		if body1.bodyName != 'Sun':
			for body2 in bodies:
				if body1 != body2:
					var pos1 = body1.position
					var pos2 = body2.position
					var r = pos1.distance_to(pos2)
					v += sqrt(GRAVITY * body2.mass / r)
			body1.velocity = Vector2(0, -v) * 0.2


# func _process(delta):
# 	if 
#     for obj_1 in bodies:
#         for obj_2 in bodies:
#             if obj_1 != obj_2:
#                 newtonian_gravity(delta, obj_1, obj_2)


func newtonian_gravity(delta, obj_1, obj_2):
    obj_1.velocity += (obj_2.global_transform.origin\
        - obj_1.global_transform.origin).normalized()\
        * GRAVITY * obj_2.mass\
        / pow((obj_2.global_transform.origin.\
        distance_to(obj_1.global_transform.origin)), 2) * delta
    obj_1.move_and_slide(obj_1.velocity, Vector2.UP)