extends Node  # ✅ Change from HTTPRequest to Node

class_name APIRequest

signal dialog_generated(response: String)

var api_link: String = ""
var api_token: String = ""
var api_model: String = ""

var messages: Array = []
var http: HTTPRequest  # ✅ Persistent HTTPRequest	

func _init() -> void:
	"""
	debugging project settings since it never worked.
	it works!!!!
	"""
	#debug_project_settings()
	
func debug_project_settings():
	print("\n🔍 Checking Project Settings before loading:")
	print("ai_dialog/api_url exists? ", ProjectSettings.has_setting("api_url"))
	print("ai_dialog/api_token exists? ", ProjectSettings.has_setting("api_token"))
	print("ai_dialog/api_model exists? ", ProjectSettings.has_setting("api_model"))

	if ProjectSettings.has_setting("api_url"):
		print("🔗 API URL:", ProjectSettings.get("api_url"))
	if ProjectSettings.has_setting("api_token"):
		print("🔑 API Token:", ProjectSettings.get("api_token"))
	if ProjectSettings.has_setting("api_model"):
		print("🤖 API Model:", ProjectSettings.get("api_model"))
		
func check_and_load_settings():
	if ProjectSettings.has_setting("api_url"):
		api_link = ProjectSettings.get("api_url")
	else:
		push_warning("🚨 Warning: api_url not found in ProjectSettings!")

	if ProjectSettings.has_setting("api_token"):
		api_token = ProjectSettings.get_setting("api_token")

	if ProjectSettings.get_setting("api_model"):
		api_model = ProjectSettings.get_setting("api_model")

func _ready():
	"""Ensures HTTPRequest is properly initialized in the scene tree """
	check_and_load_settings()
	http = HTTPRequest.new()
	add_child(http)  # ✅ Now HTTPRequest is persistent
	http.connect("request_completed", Callable(self, "_on_request_completed"))

func update_messages(new_messages: Dictionary):
	self.messages.append(new_messages)

func get_all_messages() -> Array:
	return self.messages

func clear_messages():
	self.messages.clear()

# Function to send a request
func generate_dialog(msg: String) -> String:
	var headers = [
		"Authorization: Bearer " + self.api_token,
		"Content-Type: application/json"
	]
	var payload = {
		"model": self.api_model,
		"messages": self.messages
	}
	update_messages({
		"role": "user",
		"content": msg
	})

	# ✅ Use persistent HTTPRequest
	var error = http.request(self.api_link, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if error != OK:
		push_error("HTTPRequest failed with error code: " + str(error))
		return "I seem to be having troubles right now. Talk to me afterwards."

	var response: String = await dialog_generated
	return response

func _on_request_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	if response and "choices" in response:
		var reply = response["choices"][0]["message"]["content"]
		update_messages({
			"role": "assistant",
			"content": reply
		})
		emit_signal("dialog_generated", reply)
	
