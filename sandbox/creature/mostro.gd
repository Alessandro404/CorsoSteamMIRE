extends Area3D
class_name Mostro


@onready var player_detector: Area3D 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")



@export var MOVE_SPEED = 4
var parent 


func _ready() -> void:
	parent = get_parent()
	if has_node("PlayerDetector"): player_detector = $PlayerDetector
	
	if player_detector and player_detector.is_visible_in_tree():
		player_detector.connect("player_seen", _on_player_detected)


func _on_body_entered(body: Node3D) -> void:
	look_at(%giocatore.global_position)
	player.look_at(self.global_position)
	if body.has_method("die"):
		animation_player.play("CharacterArmature|Punch")
		body.die()

func _on_player_detected(body: Node3D) -> void:
	look_at(%giocatore.global_position)
	if body.has_method("die"):
		body.die()
