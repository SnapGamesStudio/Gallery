extends StaticBody3D
class_name Door

var page:String
var next_page:String

var request_manager:RequestManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	request_manager = get_node("../../../../RequestManager")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func requested():
	if next_page:
		request_manager.create_api_request(next_page)
