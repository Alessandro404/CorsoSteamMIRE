extends Node3D
class_name CambiaTempo

@onready var direct_light: DirectionalLight3D = %DirectLight
@onready var world_environment: WorldEnvironment = %WorldEnvironment

enum TEMPO_ATMOSFERICO {SERENO, NOTTURNO, NUVOLOSO}

@export var scelta_tempo: TEMPO_ATMOSFERICO
@export_category("Immagini sfondo")
@export var sky_sereno: CompressedTexture2D 
@export var sky_notturno: CompressedTexture2D 
@export var sky_nuvoloso: CompressedTexture2D 

func _ready() -> void:
	check_tempo()

func check_tempo() -> void:
	if direct_light and world_environment:
		$Clouds.hide()
		$Moon.hide()
		$Sun.hide()
		match scelta_tempo:
			TEMPO_ATMOSFERICO.SERENO:
				print("E' Sereno")
				$Sun.show()
				cambia_aspetto(1.0, Color(1,1,1,1), 1.0, sky_sereno)
			TEMPO_ATMOSFERICO.NOTTURNO:
				print("E' Notte")
				$Moon.show()
				cambia_aspetto(0.2, Color(0.286, 0.473, 0.578, 1.0), 0.2, sky_notturno)
			TEMPO_ATMOSFERICO.NUVOLOSO:
				print("E' Nuvolo")
				$Clouds.show()
				cambia_aspetto(0.5, Color(0.541, 0.761, 0.761, 1.0), 0.5, sky_nuvoloso)

func cambia_aspetto(l_energy : float, l_color :Color, w_energy: float, sky_texture: CompressedTexture2D) -> void:
	direct_light.light_energy = l_energy
	direct_light.light_color = l_color
	world_environment.environment.background_energy_multiplier = w_energy
	world_environment.environment.sky.sky_material.panorama = sky_texture

func action() -> void:
	if scelta_tempo == TEMPO_ATMOSFERICO.SERENO:
		scelta_tempo = TEMPO_ATMOSFERICO.NOTTURNO
	elif scelta_tempo == TEMPO_ATMOSFERICO.NOTTURNO:
		scelta_tempo = TEMPO_ATMOSFERICO.NUVOLOSO
	elif scelta_tempo == TEMPO_ATMOSFERICO.NUVOLOSO:
		scelta_tempo = TEMPO_ATMOSFERICO.SERENO
	check_tempo()
