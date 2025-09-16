extends Node3D

@onready var wall: CSGBox3D = $wall
@onready var inside: CSGBox3D = $wall/inside
@onready var right_door: CSGBox3D = $wall/right_door
@onready var left_door: CSGBox3D = $wall/left_door


@export var size:Vector3
@export var offset:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wall.position += offset
	
	wall.size = size
	inside.size = size - Vector3(0.1,0.1,0.1)

	
	var rad:int = wall.size.x / 2
	
	right_door.position += Vector3(rad,0,0)
	right_door.global_position.y = 1.5
	
	left_door.position -= Vector3(rad,0,0)
	left_door.global_position.y = 1.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
