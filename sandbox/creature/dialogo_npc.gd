extends DialogoManager


var animation_player: AnimationPlayer 
@export var nome_animazione_idle : String 
@export var nome_animazione_talk : String 
@export var talk_loop : bool = false

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

var anim_idle
var anim_talk

func _ready() -> void:
	animation_player = find_child("AnimationPlayer")
	

	anim_idle = animation_player.get_animation(nome_animazione_idle)
	anim_talk = animation_player.get_animation(nome_animazione_talk)
	
	anim_idle.loop_mode = Animation.LOOP_LINEAR
	if talk_loop:
		anim_talk.loop_mode = Animation.LOOP_LINEAR
	
	animation_player.play(nome_animazione_idle)

func action():
	rotate_with_tween()
	animation_player.play(nome_animazione_talk)
	super()
	await animation_player.animation_finished
	animation_player.play(nome_animazione_idle)
	
func rotate_with_tween():
	var target_pos = player.global_position
	target_pos.y = global_position.y # Mantieni l'altezza
	
	# 1. Calcola il Transform che guarda il target
	var target_transform = global_transform.looking_at(target_pos, Vector3.UP)
	
	# 2. Estrai il quaternione dal Transform target
	var target_quat = target_transform.basis.get_rotation_quaternion()
	
	# 3. Crea il Tween animando la proprietà "quaternion" del NODO (self)
	var tween = create_tween()
	tween.tween_property(self, "quaternion", target_quat, 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
