extends Node3D

@onready var wall: CSGBox3D = $wall
@onready var inside: CSGBox3D = $wall/inside
@onready var right_hole: CSGBox3D = $wall/right_door
@onready var left_hole: CSGBox3D = $wall/left_door
@onready var roof: CSGCylinder3D = $wall/Roof/CSGCylinder3D

@onready var roof_cutout_2: CSGBox3D = $"wall/Roof/CSGCylinder3D/roof cutout2"
@onready var roof_cutout_1: CSGCylinder3D = $"wall/Roof/CSGCylinder3D/roof cutout1"

const info_prefab = preload("res://scenes/info.tscn")
const door_prefab = preload("res://scenes/door.tscn")
const plant_prefab = preload("res://scenes/pot plant.tscn")

@export var size:Vector3
@export var offset:Vector3

var page:String
var next_page:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wall.position += offset
	
	wall.size = size
	inside.size = size - Vector3(0.1,0.1,0.1)
	
	var rad:int = wall.size.x / 2
	
	#roof.radius = size.z/2
	#roof.height = size.x
	
	#roof_cutout_1.radius = size.z/2 - 0.1
	#roof_cutout_1.height = size.x
	right_hole.position += Vector3(rad,0,0)
	right_hole.global_position.y = 1.5
	
	var right_door = door_prefab.instantiate()
	right_door.next_page = next_page
	right_door.page = page
	add_child(right_door)
	right_door.global_position = right_hole.global_position
	
	
	#$wall/Roof.position.y = 10
	#var light_start_spawn = global_position - Vector3(rad,0,0)
	#var light_amount_spacing = wall.size.x / 3
	
	#for i in 3:
	#	var light_pos = light_start_spawn * i
		#var light = OmniLight3D.new()
		#get_parent().add_child(light)
		#light.global_position = light_pos
		
		
	
	if page != "https://api.artic.edu/api/v1/artworks?page=1":
		left_hole.position -= Vector3(rad,0,0)
		left_hole.global_position.y = 1.5
	else:
		var info = info_prefab.instantiate()
		info.position.y -= size.y/2
		$"info page".add_child(info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
