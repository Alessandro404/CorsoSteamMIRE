extends Node3D
class_name OggettoProgrammabile

var animation_player: AnimationPlayer 
var status: bool = 1
@onready var collision_nodes: Array[Node]

func _ready():
	if $AnimationPlayer: 
		animation_player = $AnimationPlayer 
		Singleton.add_to_doors(self)
	collision_nodes = find_children("*", "StaticBody3D")
	for i in collision_nodes.size():
		collision_nodes[i].set_owner(self)
	print(collision_nodes)

	
func _process(_delta):
	pass

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
		if status: 
			apri_porta()
		else:
			chiudi_porta()
