extends Mostro
class_name MostroPercorso


func _physics_process(delta: float) -> void:
	if parent is PathFollow3D:
		parent.progress += MOVE_SPEED * delta
