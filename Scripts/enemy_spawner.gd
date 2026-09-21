extends Node2D

@export var enemy_scene: PackedScene = preload("res://Scenes/enemy.tscn")
@export var min_time: float = 0.0
@export var max_time: float = 3.0

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.timeout.connect(_spawn_enemy)
	_reset_timer()


func _reset_timer() -> void:
	# Assign a random time for the next spawn
	spawn_timer.wait_time = randf_range(min_time, max_time)
	spawn_timer.start()

func _spawn_enemy() -> void:
	print("enemy spawned")
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		
		# Determine screen X limits (e.g., between 50px and 1100px)
		var random_x = randf_range(50.0, 400.0)
		
		# Position above the screen on Y (outside the visible frame)
		enemy.global_position = Vector2(random_x, 60)
		
		get_tree().current_scene.add_child(enemy)
	
	_reset_timer()
