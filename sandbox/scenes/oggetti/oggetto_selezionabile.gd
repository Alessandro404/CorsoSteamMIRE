@tool
extends Node3D

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
		if get_child_count() > 0:
			get_child(0).queue_free()
		add_child(model_istance)
		#devo fare tutto nel setter per non andare in recursione in editor...


var collision
var material 
var selected = false

func _ready():
	#Questo avviene quando il gioco parte, quindi la risorsa viene ricordata
	collision = get_child(0).get_child(0).get_child(0)
	material = get_child(0).get_child(0).get_mesh().surface_get_material(0)
	if not Engine.is_editor_hint():
		get_tree().get_first_node_in_group("player")._on_interact_with_object.connect(set_selected)
	


#ancora non funziona non ci sono collisioni
func _process(_delta):
	material = get_child(0).get_child(0).get_mesh().surface_get_material(0)
	collision = get_child(0).get_child(0).get_child(0)
	if not Engine.is_editor_hint():
		if selected:
			material.set_stencil_mode(1)
			material.set_stencil_effect_color(Color(0.808, 0.0, 0.0, 1.0))
		else:
			material.set_stencil_mode(0)
		pass


func set_selected(object):
	#questo ultimo  dopo && è perché c'è un frame in cui  è freed object
	if  collision == object && collision: 
		selected = true
	else:
		selected = false
