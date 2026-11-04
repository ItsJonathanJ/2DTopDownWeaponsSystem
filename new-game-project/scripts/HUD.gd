extends CanvasLayer

func _ready():
	GameManager.coin_collected.connect(update_coins)
	GameManager.game_over.connect(show_lose_screen)
	GameManager.game_won.connect(show_win_screen)
	$GameOverPanel.hide()

func update_coins(amount):
	$CoinText.text = "Coins: " + str(amount) + " / " + str(GameManager.required_coins)

func show_lose_screen():
	$GameOverPanel/MessageText.text = "You Died!"
	$GameOverPanel.show()

func show_win_screen():
	$GameOverPanel/MessageText.text = "You Win!"
	$GameOverPanel.show()

# Connect the RestartButton's pressed signal here
func _on_restart_button_pressed():
	GameManager.reset_game()
	GameManager.play_click_sound()
