extends Porta
class_name  PortaLucchetto

@export var key_id_required: String = "nessuna chiave!"

var closed_sound: Resource = preload("res://assets/import/491952__cmilo1269__bloocked-door.wav")

func _ready():
	super()
	sound_node.set_stream(closed_sound)


func action():
	if key_id_required in Singleton.keys_found:
		print("Accesso consentito!")
		super()
	else:
		print("Porta bloccata: serve la chiave ", key_id_required)
		sound_node.play()
		return # Interrompe la funzione, la porta non si apre


func _process(_delta):
	await get_tree().create_timer(1).timeout
	if key_id_required in Singleton.keys_found and $"Simple Padlock":
		sound_node.set_stream(open_sound)
		$"Simple Padlock".queue_free()
