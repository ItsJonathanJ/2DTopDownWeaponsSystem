extends Control

func _on_start_game_pressed() -> void:
	GameManager.play_click_sound()
	GameManager.reset_game()

func _on_quit_game_pressed() -> void:
	GameManager.play_click_sound()
	get_tree().quit()

func _on_restart_game_pressed() -> void:
	GameManager.play_click_sound()
	GameManager.reset_game()
