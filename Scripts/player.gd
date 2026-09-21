extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 0.0
@export var bullet: PackedScene = preload("res://Scenes/bullet_player.tscn")
@export var hard_bullet: PackedScene = preload("res://Scenes/big_bullet_player.tscn")
@onready var bullet_point: Node2D = $Bullet_point
@onready var bullet_point_2: Node2D = $Bullet_point2
@onready var hard_bullet_Point: Node2D = $Hard_bullet_point
@onready var soft_shoot_time: Timer = $soft_shoot_time
@onready var hard_shoot_time: Timer = $hard_shoot_time
@onready var ira_matera_time: Timer = $ira_matera_time
@onready var Sprite: Sprite2D = $Sprite2D
var can_shoot: bool = true
var health = 100.0
var hard_can_shoot: bool = true

func _ready() -> void:
	ira_matera_time.start()

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	
	print("ira matera: ", Global.ira_matera)
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if Input.is_action_just_pressed("blue") and can_shoot:
		soft_shoot()
		
	if Input.is_action_just_pressed("Yellow") and hard_can_shoot:
		hard_shoot()
		
	if Input.is_action_just_pressed("Red") and Global.ira_matera == true:
		$iraMateraFX.play()
		Sprite.texture = load("res://Assets/Img/Player_ult.png")
		print("ira matera")
		Global.ira_matera = false
		Global.enemy_damage *= 1.5
		Global.enemy_bullet_damage *= 3
		Global.soft_shoot_damage *= 3
		Global.hard_shoot_damage *= 3
		$Ira_matera_duration.start()
		ira_matera_time.start()
	if Global.health == 0.0:
		die()


	move_and_slide()

func soft_shoot() -> void:
	can_shoot = false
	if bullet:
		var new_bullet = bullet.instantiate()
		var new_bullet2 = bullet.instantiate()
		new_bullet.global_position = bullet_point.global_position
		new_bullet2.global_position = bullet_point_2.global_position
		get_tree().current_scene.add_child(new_bullet)
		get_tree().current_scene.add_child(new_bullet2)
		$shotFX.play()
	
	soft_shoot_time.start()
	
func hard_shoot() -> void:
	hard_can_shoot = false
	if hard_bullet:
		var new_bullet = hard_bullet.instantiate()
		new_bullet.global_position = hard_bullet_Point.global_position
		get_tree().current_scene.add_child(new_bullet)
		$hardShotFX.play()
	
	hard_shoot_time.start()

func _on_soft_shoot_time_timeout() -> void:
	can_shoot = true 	

func enemy_damage() -> void:
	print("damage")
	Global.health -= Global.enemy_damage
	
func bullet_damage() -> void:
	print("damage")
	Global.health -= Global.enemy_bullet_damage
	
func die():
	Global.lost = true
func _on_hard_shoot_time_timeout() -> void:
	hard_can_shoot = true


func _on_ira_matera_time_timeout() -> void:
	Global.ira_matera = true
	ira_matera_time.start()


func _on_ira_matera_duration_timeout() -> void:
	Sprite.texture = load("res://Assets/Img/player.png")
	Global.enemy_damage = 10
	Global.enemy_bullet_damage = 5
	Global.soft_shoot_damage = 10
	Global.hard_shoot_damage = 30
