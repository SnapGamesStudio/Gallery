extends Node

@export var image_container:Node3D
@export var request_manager:RequestManager

var current_page:String
var last_pos:Vector3 = Vector3(0,1,0)
var images:Dictionary ## saves the images so we dont need to regen the textures

func _ready() -> void:
	pass

func _on_request_manager_texture_created(texture: ImageTexture) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_texture = texture
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	var meshinstance := MeshInstance3D.new()
	meshinstance.mesh = QuadMesh.new()
	meshinstance.material_override = material
	meshinstance.position = last_pos + Vector3(1,0,0)
	last_pos += Vector3(1,0,0)
	
	image_container.add_child(meshinstance)
	
	images[current_page].images[meshinstance.position] = {
		"texture":texture
	}
	
func _on_request_manager_fnished_page(next_page: String) -> void:
	print(next_page)
	
	## starts a new page
	#request_manager.create_api_request(next_page)


func _on_request_manager_create_page_dict(page: String) -> void:
	current_page = page
	
	images[page] = {
		"images":{}
	}
