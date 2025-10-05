extends Node
class_name TextureManager

@export var player_container:Node3D
@export var image_container:Node3D
@export var request_manager:RequestManager

const player_prefab = preload("res://scenes/player.tscn")

var current_page_number:int
var current_page:String
var last_pos:Vector3 = Vector3(0,1,0)
var images:Dictionary ## saves the images so we dont need to regen the textures

func _ready() -> void:
	pass

func _on_request_manager_texture_created(texture: ImageTexture) -> void:
	
	images[current_page].images[last_pos + Vector3(1,0,0) ] = {
		"texture":texture,
	}
	
	last_pos += Vector3(1,0,0) 
	
	#var a = AABB(Vector3(0,0,0),Vector3(0,0,0))
	#a = a.expand(last_pos + Vector3(0.2,0.2,0.2))
	#print(a)
	images[current_page].aabb = images[current_page].aabb.expand(last_pos + Vector3(0.5,0.5,0.5))
	
func _on_request_manager_fnished_page(page: String,page_number:int,next_page:String) -> void:
	$"../WorldManager".gen_room(current_page,page_number,next_page)
	print(next_page)
	
	for door in get_tree().get_nodes_in_group("Door"):
		if door.next_page == page:
			door.queue_free() 
			
	$"../TextureRect".hide()
	$"../loading page".hide()
	
	## starts a new page
	if page_number == 1:
		var player = player_prefab.instantiate()
		player.position = Vector3(18,5,5)
		player_container.add_child(player)
		$"../Label".hide()
		
		#request_manager.create_api_request(next_page)
		pass

func _on_request_manager_create_page_dict(page: String, page_number: int) -> void:
	current_page = page
	current_page_number = page_number
	
	images[page] = {
		"images":{},
		"aabb":AABB()
	}
