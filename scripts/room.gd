extends Node3D

@onready var wall: CSGBox3D = $wall
@onready var inside: CSGBox3D = $wall/inside
@onready var right_hole: CSGBox3D = $wall/right_door
@onready var left_hole: CSGBox3D = $wall/left_door

const door_prefab = preload("res://scenes/door.tscn")

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
	
	right_hole.position += Vector3(rad,0,0)
	right_hole.global_position.y = 1.5
	
	var right_door = door_prefab.instantiate()
	right_door.next_page = next_page
	right_door.page = page
	add_child(right_door)
	right_door.global_position = right_hole.global_position
	
	if page != "https://api.artic.edu/api/v1/artworks?page=1":
		left_hole.position -= Vector3(rad,0,0)
		left_hole.global_position.y = 1.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
