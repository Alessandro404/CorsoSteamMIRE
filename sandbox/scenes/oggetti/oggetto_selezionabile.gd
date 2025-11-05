@tool
extends StaticBody3D

@onready var placeholder_mesh : PackedScene = preload("res://assets/prototyping/floating_question_mark.tscn")
@export var model : PackedScene:
	get: return model
	set(new_model): 
		model = new_model
		if model:
			model = load(model.resource_path)
		else:
			model = load(placeholder_mesh.resource_path)
		var model_istance = model.instantiate()
		if get_child(0):
			get_child(0).queue_free()
		add_child(model_istance)


func _ready():
	pass
	
