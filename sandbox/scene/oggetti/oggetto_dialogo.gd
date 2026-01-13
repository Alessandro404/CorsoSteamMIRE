@tool
extends OggettoSelezionabile

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


func _init():
	placeholder_mesh = preload("res://assets/prototyping/floating_dialogue.tscn")
	model = placeholder_mesh

func _process(_delta):
	super(_delta)
	

func dialogue_action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	
