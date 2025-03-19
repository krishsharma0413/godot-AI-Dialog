@tool
extends EditorPlugin

var settings_panel

func _enter_tree():

	# ✅ Force register missing settings
	register_setting("global/api_url", "https://openrouter.ai/api/v1/chat/completions", TYPE_STRING)
	register_setting("global/api_token", "", TYPE_STRING)
	register_setting("global/api_model", "meta-llama/llama-3.3-70b-instruct:free", TYPE_STRING)	
	# ✅ Register UI Panel
	settings_panel = preload("res://addons/ai_dialog/AIPluginSettings.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, settings_panel)
	print("✅ AI Dialog Plugin UI Loaded!")

func _exit_tree():
	remove_control_from_docks(settings_panel)
	settings_panel.queue_free()
	print("❌ AI Dialog Plugin UI Unloaded!")

func register_setting(name: String, default_value, type: int):
	if not ProjectSettings.has_setting(name):
		print("📌 Creating missing setting:", name)
		ProjectSettings.set(name, default_value)
		ProjectSettings.set_initial_value(name, default_value)  # Ensures it persists
		ProjectSettings.save()
		print("created: ", name)
	else:
		print("✅ Setting already exists:", name, "=", ProjectSettings.get(name))
