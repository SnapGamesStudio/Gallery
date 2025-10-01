extends Node

@export var room_container:Node3D

const Room = preload("res://scenes/Room.tscn")

@export var texture_manager:TextureManager

func gen_room(page:String,page_number:int,next_page:String):
	var width:float
	
	width = texture_manager.images[page].images.size() * 1.5
	
	var images_aabb:AABB = texture_manager.images[page].aabb
	
	print("room_width ",width)
	
	var room = Room.instantiate()
	room.page = page
	room.next_page = next_page
	
	room.size = Vector3(width,10,10)
	
	print("room_pos ",images_aabb)
	
	var room_position = Vector3(images_aabb.size.x / 2, 10/2,10/2)
	room.position = Vector3(18 * page_number,room_position.y,room_position.z)

	room_container.add_child(room)
	
	spawn_image_frames(room.position,width,texture_manager.images[page].images)

func spawn_image_frames(room_position:Vector3, room_width:float,images:Dictionary):
	var start_spawn = room_position - Vector3(room_width/3,0,0)
	start_spawn.y = 1
	
	for img in images:
		var texture = images[img].texture
		
		var material := StandardMaterial3D.new()
		material.albedo_texture = texture
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
		
		var meshinstance := MeshInstance3D.new()
		meshinstance.mesh = QuadMesh.new()
		meshinstance.material_override = material
		meshinstance.position = start_spawn
		start_spawn += Vector3(1,0,0)
		
		$"../World/Images".add_child(meshinstance)
