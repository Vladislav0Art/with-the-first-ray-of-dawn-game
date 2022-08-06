extends CanvasLayer




func _on_StartGameButton_pressed():
	get_tree().change_scene("res://src/world/World.tscn")


func _on_ExitGameButton_pressed():
	get_tree().quit()
