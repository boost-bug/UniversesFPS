extends Node2D

func _ready():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request("https://raw.githubusercontent.com/boost-bug/UniversesFPS/master/build/ver")
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var response = body.get_string_from_utf8()

	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	if not int(response) == ProjectSettings.get_setting("global/Ver Number"):
		$AnimationPlayer.play("popUp")
	

func _ClosePopup():
	$AnimationPlayer.play("popDown")

func _InstallUpdate():
	OS.shell_open("https://github.com/boost-bug/UniversesFPS/blob/master/build/build.7z?raw=true")
	$AnimationPlayer.play("popDown")
