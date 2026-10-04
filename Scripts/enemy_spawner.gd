extends Node2D

@export var enemy_scene: PackedScene = preload("res://Scenes/enemy.tscn")
@export var min_time: float = 2.0
@export var max_time: float = 4.0

@onready var spawn_timer: Timer = $SpawnTimer


var wave_timer: Timer


var waves_config: Array = [
	{"sequence": 1, "max_enemies": 7, "min_time": 0.3, "max_time": 1.0}, 
	{"sequence": 2, "max_enemies": 5, "min_time": 2.0, "max_time": 3.0}, 
	{"sequence": 0, "max_enemies": 3, "min_time": 2.0, "max_time": 3.0}  
]

var current_wave_index: int = 0
var current_max_enemies: int = 2

func _ready() -> void:
	spawn_timer.timeout.connect(_spawn_enemy)
	

	wave_timer = Timer.new()
	wave_timer.wait_time = 20.0
	wave_timer.one_shot = false
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	add_child(wave_timer)
	
	_start_wave(0)
	wave_timer.start()
	_reset_timer()


func _start_wave(wave_index: int) -> void:
	if wave_index < waves_config.size():
		current_wave_index = wave_index
		

		Global.sequence = waves_config[wave_index]["sequence"]
		current_max_enemies = waves_config[wave_index]["max_enemies"]
		min_time = waves_config[wave_index]["min_time"]
		max_time = waves_config[wave_index]["max_time"]
		
		print("Iniciando Oleada ", wave_index + 1, " | Secuencia Global: ", Global.sequence, " | Máx Enemigos: ", current_max_enemies)
	else:

		_on_waves_completed()


func _on_wave_timer_timeout() -> void:
	_start_wave(current_wave_index + 1)


func _reset_timer() -> void:

	spawn_timer.wait_time = randf_range(min_time, max_time)
	spawn_timer.start()


func _spawn_enemy() -> void:
	var current_enemy_count: int = get_tree().get_nodes_in_group("enemies").size()
	
	if current_enemy_count < current_max_enemies:
		print("Enemy spawned (Enemigos activos: ", current_enemy_count + 1, "/", current_max_enemies, ")")
		if enemy_scene:
			var enemy = enemy_scene.instantiate()

			enemy.add_to_group("enemies")
			
		
			var random_x = randf_range(50.0, 400.0)
			

			enemy.global_position = Vector2(random_x, 60)
			
			get_tree().current_scene.add_child(enemy)
	else:
		print("Límite de enemigos alcanzado en pantalla (", current_enemy_count, "/", current_max_enemies, "). Esperando...")
	
	_reset_timer()


func _on_waves_completed() -> void:
	print("Ciclo completado. Reiniciando desde la Oleada 1...")
	_start_wave(0)
