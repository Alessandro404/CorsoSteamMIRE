extends CharacterBody3D

signal interact_object
@onready var ray_cast_3d: RayCast3D = $testa/Camera3D/RayCast3D

@onready var testa: Node3D = $testa

const SPEED_WALKING : float = 5.0
const SPEED_SPRINTING : float = 11.0
const SPEED_CROUCHING : float = 3.0
const JUMP_VELOCITY : float = 4.5
var speed_current = SPEED_WALKING

var direction : Vector3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const MOUSE_SENSIBILITY : float  = 0.4
var lerp_speed : float = 20.0
var lerp_speed_floating : float = 3.0

var crouching_depth = -0.5

#Vari oggetti e collisori per muoversi
@onready var collision_shape_3d_standing: CollisionShape3D = $CollisionShape3D_standing
@onready var collision_shape_3d_standing_2: CollisionShape3D = $CollisionShape3D_standing2
@onready var collision_shape_3d_crouching: CollisionShape3D = $CollisionShape3D_crouching
@onready var collision_shape_3d_crouching_2: CollisionShape3D = $CollisionShape3D_crouching2
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D


func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSIBILITY))
		testa.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSIBILITY))
		testa.rotation.x = clamp(testa.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	if Input.is_action_pressed("crouch"):
		speed_current = SPEED_CROUCHING
		testa.position.y = lerp(testa.position.y, 1.6 + crouching_depth, delta * 20)
		collision_shape_3d_crouching.disabled = false
		collision_shape_3d_crouching_2.disabled = false
		collision_shape_3d_crouching.get_child(0).visible = true
		collision_shape_3d_standing.disabled = true
		collision_shape_3d_standing_2.disabled = true
		collision_shape_3d_standing.get_child(0).visible = false
		
		
	elif !shape_cast_3d.is_colliding():
		if Input.is_action_pressed("sprint") && is_on_floor():
		#if Input.is_action_pressed("sprint"):   ##controllo se posso cambiare velocità saltando
			speed_current = SPEED_SPRINTING
		else:
			if is_on_floor():
				speed_current = SPEED_WALKING
		
		testa.position.y = lerp(testa.position.y, 1.6, delta * 20)
		collision_shape_3d_crouching.disabled = true
		collision_shape_3d_crouching_2.disabled = true
		collision_shape_3d_crouching.get_child(0).visible = false
		collision_shape_3d_standing.disabled = false
		collision_shape_3d_standing_2.disabled = false
		collision_shape_3d_standing.get_child(0).visible = true
		
		
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	if is_on_floor():
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
	else:
		velocity.y -= gravity * delta
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed_floating)
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		
	
	
	
	if direction:
		velocity.x = direction.x * speed_current
		velocity.z = direction.z * speed_current
	else:
		velocity.x = move_toward(velocity.x, 0, speed_current)
		velocity.z = move_toward(velocity.z, 0, speed_current)
			
	move_and_slide()
	
	if Input.is_action_just_pressed("escape_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		interact_object.emit(collider)
	else:
		interact_object.emit(null)
