extends CharacterBody2D

@export var bullet: PackedScene = preload("res://Scenes/bullet_enemy.tscn")
@export var speed: float = 1.0
@export var health = 100

# Margen respecto a los bordes de la pantalla (ajusta según el tamaño del sprite)
@export var margin_x: float = 32.0 

var sequence: int = 0
var Time_acumulated: float = 0.0
var initial_position: Vector2 = Vector2.ZERO

# Definimos los límites de la pantalla
var min_x: float = 0.0
var max_x: float = 0.0

func _ready() -> void:
	initial_position = global_position
	sequence = randi_range(0, 3)

	# Obtenemos el ancho del Viewport para calcular los límites dinámicamente
	var viewport_width = get_viewport_rect().size.x
	min_x = margin_x
	max_x = viewport_width - margin_x

	$ShootTimer.wait_time = 0.8
	$ShootTimer.timeout.connect(_shoot)
	$ShootTimer.start()

func _process(delta: float) -> void:
	Time_acumulated += delta
	var base_descent: float = speed * delta

	match sequence:
		0:
			# Patrón 0: Figura en "8"
			var amplitude_x = 100.0
			var amplitude_y = 40.0
			var frequency = 3.0
			
			var offset_x = sin(Time_acumulated * frequency) * amplitude_x
			var offset_y = sin(Time_acumulated * frequency * 2.0) * amplitude_y
			
			initial_position.y += base_descent
			global_position = Vector2(initial_position.x + offset_x, initial_position.y + offset_y)

		1:
			# Patrón 1: Zig-Zag
			var freq_x = 2.5
			var freq_y = 5.0
			
			var offset_x = sin(Time_acumulated * freq_x) * 120.0
			var offset_y = cos(Time_acumulated * freq_y) * 30.0
			
			initial_position.y += base_descent
			global_position = Vector2(initial_position.x + offset_x, initial_position.y + offset_y)

		2:
			# Patrón 2: Espiral
			var radius = 60.0
			var speed_rotation = 4.0
			
			var offset_x = cos(Time_acumulated * speed_rotation) * radius
			var offset_y = sin(Time_acumulated * speed_rotation) * radius
			
			initial_position.y += base_descent
			global_position = Vector2(initial_position.x + offset_x, initial_position.y + offset_y)

		3:
			# Patrón 3: Sinuoso con Aceleración
			var offset_x = sin(Time_acumulated * 4.0) * 150.0
			var variable_descent = (sin(Time_acumulated * 3.0) + 1.2) * speed * delta
			
			initial_position.y += variable_descent
			global_position = Vector2(initial_position.x + offset_x, initial_position.y)

	# --- CONTROL DE LÍMITES EN PANTALLA ---
	# Restringimos la posición final en X para que no se salga de min_x ni max_x
	global_position.x = clamp(global_position.x, min_x, max_x)

	# Autodestrucción fuera de pantalla por abajo
	if global_position.y > 1100:
		queue_free()

func _shoot() -> void:
	if bullet:
		var new_bullet = bullet.instantiate()
		new_bullet.global_position = global_position
		get_tree().current_scene.add_child(new_bullet)

func kill():
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.enemy_damage()
