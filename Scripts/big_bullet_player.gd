extends Area2D

@export var speed = 90.0

func _physics_process(delta: float) -> void:
	position += Vector2.UP * 90 * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.health -= Global.hard_shoot_damage
		if body.health <= 0:
			body.kill()
		
