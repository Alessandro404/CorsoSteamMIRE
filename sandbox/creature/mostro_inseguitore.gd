extends CharacterBody3D

const SPEED = 2.0
#In physical frame, per fare un timer non bloccante
const AWAIT_FRAMES : int = 180
var await_time : int = 0

@export var player_detection_range : float = 12.0
@export var monster_attack_range : float = 1.1

#questa variabile per è quando il giocatore si muove e si avvicina per interrompere il return  state
@onready var monster_aggressive_range : float = player_detection_range/2

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $"Root Scene/AnimationPlayer"

var spawn_point : Marker3D
var is_in_arena : bool = false

var target_node = null
var player_near : bool = false

enum State { IDLE, CHASING, RETURNING, ATTACKING }
var current_state = State.IDLE
var previous_state = null


func _ready() -> void:
	if get_parent() is Marker3D:
		spawn_point = get_parent()
		#Giusto un controllo nel caso volessi in futuro usarlo fuori
		is_in_arena = true

func _physics_process(_delta: float) -> void:
	#print(target_node , ", ", current_state , ", ", await_time)
	
	match current_state:
			State.IDLE:
				_state_idle()
			State.CHASING:
				_state_chasing()
			State.RETURNING:
				_state_returning()
			State.ATTACKING:
				_state_attacking()
	
	move_and_slide()

func _state_idle() -> void:
	animation_player.set_current_animation("Zombie|ZombieIdle")
	velocity = Vector3.ZERO
	if is_player_in_range(player_detection_range):
		previous_state = current_state
		current_state = State.CHASING

func _state_chasing() -> void:
	animation_player.play("Zombie|ZombieRun")
	target_node = player
	if is_player_in_range(monster_attack_range):
		previous_state = current_state
		current_state = State.ATTACKING
		return
	
	if not nav_agent.is_target_reachable() and not is_player_in_range(monster_aggressive_range):
		animation_player.set_current_animation("Zombie|ZombieIdle")
		velocity = Vector3.ZERO
		await_time += 1
		if await_time > AWAIT_FRAMES:
			await_time = 0
			previous_state = current_state
			current_state = State.RETURNING
			return
		return
	elif not nav_agent.is_target_reachable():
		await_time = 0
		
	navigation()

func _state_returning() -> void:
	animation_player.play("Zombie|ZombieRun")
	target_node = spawn_point
	
	if is_player_in_range(monster_aggressive_range):
		previous_state = current_state
		current_state = State.CHASING
		return
		
	if nav_agent.is_navigation_finished():
		previous_state = current_state
		current_state = State.IDLE
	
	navigation()

func _state_attacking() -> void:
	velocity = Vector3.ZERO
	look_at(player.global_position)
	player.look_at(self.global_position)
	animation_player.play("Zombie|ZombieBite", -1, 3)
	player.die()
	await animation_player.animation_finished
	print("attacco")
	previous_state = current_state
	current_state = State.IDLE

func is_player_in_range(value) -> bool:
	if player == null: return false
	return global_position.distance_to(player.global_position) < value


func navigation() -> void:
	var look_target
	nav_agent.set_target_position(target_node.global_position)
	if nav_agent.is_navigation_finished(): 
		velocity = velocity.move_toward(Vector3.ZERO, 0.5)
		look_target = Vector3(player.global_position.x, global_position.y, player.global_position.z)
		return
	var next_pos = nav_agent.get_next_path_position()
	var current_pos = global_position
	var direction = (next_pos - current_pos).normalized()
	var distance_to_next = current_pos.distance_to(next_pos)
	if distance_to_next > 0.1:
		look_target = Vector3(next_pos.x, current_pos.y, next_pos.z)
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(direction * SPEED, 0.2)
	
	if current_pos.distance_squared_to(look_target) > 0.001:
			var target_transform = global_transform.looking_at(look_target, Vector3.UP)
			global_transform = global_transform.interpolate_with(target_transform, 0.1)

"""func navigation() -> void:
	nav_agent.set_target_position(target_node.global_position)
	
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	
	if direction.length() > 0.1:
		var look_target = Vector3(next_pos.x, global_position.y, next_pos.z)
		var target_transform = global_transform.looking_at(look_target, Vector3.UP)
		global_transform = global_transform.interpolate_with(target_transform, 0.1) # 0.1 è la velocità di rotazione
		velocity = direction * SPEED
		"""




"""	if player_near:
		target_node = player
		if nav_agent.is_target_reachable():
			target_node = player
		else:
			#await get_tree().create_timer(TIMER).timeout
			target_node = spawn_point
	else:
		target_node = spawn_point

	nav_agent.set_target_position(target_node.global_position)
	
	if not nav_agent.is_navigation_finished():
			var next_pos = nav_agent.get_next_path_position()
			var direction = (next_pos - global_position).normalized()
			velocity = direction * SPEED
"""
