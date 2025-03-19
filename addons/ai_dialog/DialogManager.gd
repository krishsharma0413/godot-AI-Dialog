extends Node

class_name  DialogManager

var client: APIRequest

func _ready() -> void:
	client = APIRequest.new()
	add_child(client)

func add_personality(personal: String) -> void:
	"""
	Add a personality to the NPC.
	"""
	client.update_messages({
		"role": "developer",
		"content": personal
	})



func get_all_messages() -> Array:
	"""
	Returns all messages in the messages array.
	Useful for storing past conversations.
	"""
	return client.get_all_messages()

func clear_messages() -> void:
	"""
	Clear past conversations with the NPC.
	"""
	client.clear_messages()

func provide_context(msg: String) -> void:
	"""
	Update the context. This is helpful for giving quests or hints to the player.
	This is different than the personality of the NPC.
	"""
	client.update_messages({
		"role": "developer",
		"content": msg
	})

func generate_dialog(msg: String) -> String:
	"""
	Generate a response from the NPC.
	"""
	var resp:String = await client.generate_dialog(msg)
	return resp
