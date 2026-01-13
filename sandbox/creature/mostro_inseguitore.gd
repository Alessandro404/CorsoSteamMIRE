extends Mostro
class_name MostroInseguitore


enum STATE {IDLE, WAITING_TO_MOVE, MOVE}
var state : STATE = STATE.IDLE

var idle_wait_time: float = 1.5
var idle_timer_count: float  = 0

@onready var navagent NavigationAgent3D = $NavigationAgent3D
