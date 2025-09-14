extends Node

var api_request:HTTPRequest
var image_request:HTTPRequest

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


	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = api_request.request("https://api.artic.edu/api/v1/artworks") ## opens page 1

	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _api_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	for image in response.data: ## the images
		print("image ",image.id)
	#print("response ",response)
		var iiif_url = response.config.iiif_url
		if image.image_id:
			var final_url:String = str(iiif_url,"/" + image.image_id,"/full/843,/0/default.jpg")
			print(final_url)
			image_request.request(final_url)
			await image_request.request_completed
			
	var page_2_url = response.pagination.next_url

func _image_request_completed(result,response_code,headers,body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)

	# Display the image in a TextureRect node.
	var texture_rect = TextureRect.new()
	add_child(texture_rect)
	texture_rect.texture = texture
