extends Node
class_name RequestManager

signal texture_created(texture:ImageTexture)
signal fnished_page(next_page:String)
signal create_page_dict(page:String)

var api_request:HTTPRequest
var image_request:HTTPRequest

@export var texture_manager:Node

func _ready():
	# Create an HTTP request node and connect its completion signal.
	api_request = HTTPRequest.new()
	api_request.name = "api_request"
	add_child(api_request,true)
	api_request.request_completed.connect(self._api_request_completed)
	
	
	image_request = HTTPRequest.new()
	image_request.name = "image_request"
	add_child(image_request,true)
	image_request.request_completed.connect(self._image_request_completed)
	
	# does a api call to get all artworks at page 1
	var error = api_request.request("https://api.artic.edu/api/v1/artworks?page=1")

	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _api_request_completed(result, response_code, headers, body):
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	var page_url = str("https://api.artic.edu/api/v1/artworks?","page=",response.pagination.current_page)
	create_page_dict.emit(page_url)
	
	for image in response.data: ## the images
		print("image ",image.id)
		
		var iiif_url = response.config.iiif_url
		if image.image_id:
			var final_url:String = str(iiif_url,"/" + image.image_id,"/full/843,/0/default.jpg")
			print(final_url)
			image_request.request(final_url)
			await image_request.request_completed
			
	var page_2_url = response.pagination.next_url
	fnished_page.emit(page_2_url)

func _image_request_completed(result,response_code,headers,body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)
	
	texture_created.emit(texture)

func create_api_request(url:String):
	var error = api_request.request(url)

	if error != OK:
		push_error("An error occurred in the HTTP request.")
