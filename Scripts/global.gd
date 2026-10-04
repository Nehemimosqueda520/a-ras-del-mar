extends Node
var isPaused:bool= true
var health: float  = 100
var enemy_damage: float = 10
var enemy_bullet_damage: float = 5
var soft_shoot_damage: float = 20
var hard_shoot_damage: float = 100
var lost: bool = false
var ira_matera:bool = false
var sequence: int = 0


	
# Called when the node enters the scene tree for the first time.
func pauseGame() -> void:
	if isPaused:
		get_tree().call_group(
			"Pause", 
			"set_process_mode", 
			Node.PROCESS_MODE_DISABLED
			)
	else:
		get_tree().call_group(
			"Pause", 
			"set_process_mode", 
			Node.PROCESS_MODE_INHERIT
			)
	print(isPaused)
