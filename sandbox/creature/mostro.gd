extends Area3D
class_name Mostro


@onready var player_detector: Area3D = $PlayerDetector

@export var MOVE_SPEED = 4
var parent 


func _ready() -> void:
	parent = get_parent()
	if player_detector.is_visible_in_tree():
		player_detector.connect("player_seen", _on_player_detected)



func _on_body_entered(body: Node3D) -> void:
	if body.has_method("die"):
		body.die()

func _on_player_detected(body: Node3D) -> void:
	if body.has_method("die"):
		body.die()
