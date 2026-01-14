extends Area3D
class_name Teleport

@export var nome_teletrasporto : String = "Nome questo teletrasporto"
@export var destinazione : String = "Nome destinazione"



func _ready() -> void:
	Singleton.add_to_teleport(self)


func send():
	pass

func receive():
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Entrato player")


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Uscito player")
