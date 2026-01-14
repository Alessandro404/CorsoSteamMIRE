extends Area3D
class_name DialogoManager

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	if !Singleton.dialogue_playing:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		Singleton.dialogue_playing = true
