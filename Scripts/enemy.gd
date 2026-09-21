extends CharacterBody2D

@export var bullet: PackedScene = preload("res://Scenes/bullet_enemy.tscn")
@export var speed: float = 150.0
@export var health = 100

var sequence: int = 0
var Time_acumulated: float = 0.0
var x_position: float = 0.0

func _ready() -> void:
	x_position = global_position.x
	sequence = randi_range(0, 2)

	$ShootTimer.wait_time = 0.8
	$ShootTimer.timeout.connect(_shoot)
	$ShootTimer.start()
	
func _process(delta: float) -> void:
	Time_acumulated += delta
	match sequence:
		0:
			pass
		1:
			var amplitude = 80.0
			var frequence = 3.0
			global_position.x = x_position + sin(Time_acumulated * frequence) * amplitude
		2:
			var direction = sign(cos(Time_acumulated * 2.0))
			global_position.x += direction * 100 * delta
	if global_position.y > 1100: # Ajusta según la resolución de tu viewport
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
