extends Area3D

@export var fov_angle: float = 45.0 
@export var reset_time: int = 2
@onready var ray = $RayCast3D


@onready var alert_box: CSGBox3D = $CSGBox3D
signal player_seen


var player = null


func _process(_delta):
	if player:
		if is_player_in_fov() and has_line_of_sight():
			alert_box.material_override.albedo_color = Color(1,0,0,1)
			player_seen.emit(player)
		

func is_player_in_fov() -> bool:
	# Calcola la direzione verso il giocatore
	var direction_to_player = (player.global_position - global_position).normalized()
	
	# Calcola quanto la direzione del nemico coincide con quella del giocatore
	# Il vettore avanti in Godot 3D è solitamente -global_transform.basis.z
	var forward_vector = -global_transform.basis.z
	
	var dot_product = forward_vector.dot(direction_to_player)
	var angle = rad_to_deg(acos(dot_product))
	
	return angle < fov_angle

func has_line_of_sight() -> bool:
	ray.look_at(player.global_position) # Punta il raycast verso il giocatore
	ray.force_raycast_update()
	
	if ray.is_colliding():
		return ray.get_collider() == player
	return false


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
		await get_tree().create_timer(reset_time).timeout
		alert_box.material_override.albedo_color = Color(0,1,0,1)
