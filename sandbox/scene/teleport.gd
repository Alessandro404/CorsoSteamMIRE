extends Area3D
class_name Teleport

@export var nome_teletrasporto : String = "Nome questo teletrasporto"
@export var destinazione : String = "Nome destinazione"

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

var cooldown : bool = false


func _ready() -> void:
	Singleton.add_to_teleport(self)


func send():
	for node in Singleton.registered_teleports:
		if node.nome_teletrasporto == destinazione:
			node.receive()

func receive():
	SceneTransition.fake_dissolve()
	cooldown = true
	player.global_position = global_position
	


func _on_body_entered(body: Node3D) -> void:
	if body == player and not cooldown:
		#print("entrato player")
		send()


func _on_body_exited(body: Node3D) -> void:
	if body == player:
		print("Uscito player")
		cooldown = false
