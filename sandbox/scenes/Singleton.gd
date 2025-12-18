extends Node

@onready var dialogue_playing : bool = false:
	set(value):
		if !value:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			await get_tree().create_timer(0.5).timeout
		dialogue_playing = value


@onready var registered_doors: Array[OggettoProgrammabile] = []

func apri_porta(porta) ->void:
	registered_doors[porta].apri_porta()

func chiudi_porta(porta) ->void:
	registered_doors[porta].chiudi_porta()
	
func toggle_porta(porta) -> void:
	if registered_doors[porta].status: apri_porta(porta)
	else: chiudi_porta(porta)

func add_to_doors(node) -> void:
	registered_doors.append(node)
	print(registered_doors)
