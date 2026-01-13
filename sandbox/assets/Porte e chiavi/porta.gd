extends Node3D
class_name Porta

var status: bool = true
@onready var collision_nodes: Array[Node]
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sound_node = $AudioStreamPlayer3D
var open_sound = preload("res://assets/import/15419__pagancow__dorm-door-opening.wav")

func _ready():
	sound_node.set_stream(open_sound)
	Singleton.add_to_doors(self)
	collision_nodes = find_children("*", "StaticBody3D")
	for node in  collision_nodes:
		node.set_owner(self)

	
func apri_porta():
	if animation_player:
		if status: 
			animation_player.play("open")
			await animation_player.animation_finished 
	status = !status

func chiudi_porta():
	if animation_player:
		if !status: 
			animation_player.play("close")
			await animation_player.animation_finished 
	status = !status

func toggle_porta():
	if animation_player:
		sound_node.play()
		if status: 
			apri_porta()
		else:
			chiudi_porta()

func action() -> void:
	toggle_porta()
