extends Area2D

@export var velocity = 300.0

func _physics_process(delta: float) -> void:
	position += Vector2.DOWN * velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.bullet_damage()
