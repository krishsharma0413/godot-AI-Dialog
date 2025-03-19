@tool
extends Control

@onready var api_key_input = $VBoxContainer/HBoxContainerAPI/ApiKeyInput
@onready var model_input = $VBoxContainer/HBoxContainerModel/ModelInput
@onready var api_url_input = $VBoxContainer/HBoxContainerAPIURL/ApiURLInput
@onready var save_button = $VBoxContainer/SaveButton

func _ready():
	if not Engine.is_editor_hint():
		queue_free()  # Ensure this script runs only in the editor

	# Load saved settings from Project Settings
	api_key_input.text = ProjectSettings.get("global/api_token")
	api_url_input.text = ProjectSettings.get("global/api_url")
	model_input.text = ProjectSettings.get("global/api_model")

	# Connect save button
	save_button.pressed.connect(_save_settings)

func _save_settings():
	# Save to Project Settings
	ProjectSettings.set_setting("global/api_token", api_key_input.text)
	ProjectSettings.set_setting("global/api_model", model_input.text)
	ProjectSettings.set_setting("global/api_url", api_url_input.text)
		# Ensure the settings persist
	ProjectSettings.save()
	print("✅ AI Dialog Settings Saved!")
