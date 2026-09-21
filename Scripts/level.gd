extends Node2D
@onready var MainMenu:Node2D = $mainMenu


func _process(_delta: float) -> void:
	Global.pauseGame()
	
	if Input.is_action_just_pressed("Yellow") and Global.isPaused == true:
		$GameTimer.start()
		
		if MainMenu.visible == true:
			Global.isPaused = false
		MainMenu.visible = !MainMenu.visible
		$loseScene.visible = false
		$Winscene.visible = false
		Global.lost = false
	
	if Global.lost == true:
		Global.isPaused = true
		$loseScene.visible = true
		Global.health = 100
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.queue_free()
			
	if Global.ira_matera == true:
		$buttonIraMatera/ColorRect.visible = false
	else:
		$buttonIraMatera/ColorRect.visible = true
		
	if $Player.hard_can_shoot:
		$buttonBigShot/ColorRect.visible = false   
	else:
		$buttonBigShot/ColorRect.visible = true   


func _unhandled_input(event):
	if event.is_pressed() and not event.is_echo():
		
		for action in InputMap.get_actions():
			
			if action.begins_with("ui_"):
				continue
				
			if event.is_action_pressed(action):
				print("Se presionó: ", action)


func _on_game_timer_timeout() -> void:
	Global.isPaused = true
	$Winscene.visible = true
	Global.health = 100
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
