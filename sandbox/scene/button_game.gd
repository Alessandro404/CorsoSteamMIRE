extends Node3D
class_name ButtonGame

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bottone: CSGBox3D = $bottone
var premuto : bool = false

func _ready() -> void:
	Singleton.add_to_buttons(self)

func action() -> void:
	
	if !premuto:
		animation_player.play("press")

	else:
		animation_player.play_backwards("press")
	premuto = !premuto
	
