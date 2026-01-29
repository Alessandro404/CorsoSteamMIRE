extends Area3D
class_name Teleport

@export var nome_teletrasporto : String = "Nome questo teletrasporto"
@export var destinazione : String = "Nome destinazione"
@export var monouso: bool = false

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

var cooldown : bool = false

enum Levels {LIVELLO1, LIVELLO2, LIVELLO3, LIVELLO4, LIVELLO5}
@export var livello_obiettivo: Levels


func _ready() -> void:
	Singleton.add_to_teleport(self)
	$CollisionShape3D/CSGMesh3D.hide()
func send():
	var level_name_parts =  get_tree().get_current_scene().get_name().split("_")
	
	if level_name_parts.size() > 1:
	
		if not level_name_parts[1].to_int() == livello_obiettivo+1:
		
			SceneTransition.load_and_change_level(livello_obiettivo, destinazione)
	else: SceneTransition.load_and_change_level(livello_obiettivo, destinazione)
	
	for node in Singleton.registered_teleports:
		if node.nome_teletrasporto == destinazione:
			node.receive()
	if monouso:
		queue_free()


func receive(dissolve = true):
	if dissolve:
		SceneTransition.fake_dissolve()
		await get_tree().create_timer(0.5).timeout
	cooldown = true
	player.global_position = global_position
	player.rotation.y = rotation.y
	if monouso:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body == player and not cooldown:
		send()


func _on_body_exited(body: Node3D) -> void:
	if body == player:
		cooldown = false


func _exit_tree() -> void:
	# Remove this teleport from the list when the level changes
	if Singleton.registered_teleports.has(self):
		Singleton.registered_teleports.erase(self)
