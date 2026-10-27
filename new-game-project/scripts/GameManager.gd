extends Node


signal coin_collected(total_coins)
signal game_over
signal game_won

var coins : int = 0
var required_coins : int = 3
var click_sfx_stream = preload("res://assets/AUDIO/Button_Click.mp3")
var victory_sfx_stream = preload("res://assets//AUDIO/alex-morgan-fantasy-adventure-quest-.mp3")
var defeat_sfx_stream = preload("res://assets//AUDIO/jorisvermeer-mysterious-fairytale-journey.mp3")

func add_coin():
	coins += 1
	coin_collected.emit(coins)
	if coins >= required_coins:
		win_game()
	
func play_click_sound():
	if click_sfx_stream:
		var sfx_player = AudioStreamPlayer2D.new()
		sfx_player.stream = click_sfx_stream
		sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS # Plays even when paused
		add_child(sfx_player)
		sfx_player.play()
		sfx_player.finished.connect(sfx_player.queue_free) # Auto-delete when done

func play_victory_music():
	if victory_sfx_stream:
		var music_player = AudioStreamPlayer.new()
		music_player.name = "VictoryMusicPlayer"
		music_player.stream = victory_sfx_stream
		music_player.process_mode = Node.PROCESS_MODE_ALWAYS # Plays even when paused
		add_child(music_player)
		music_player.play()
		
func play_defeat_music():
	if defeat_sfx_stream:
		var music_player = AudioStreamPlayer.new()
		music_player.name = "DefeatMusicPlayer"
		music_player.stream = defeat_sfx_stream
		music_player.process_mode = Node.PROCESS_MODE_ALWAYS # Plays even when paused
		add_child(music_player)
		music_player.play()
		
func lose_game():
	play_defeat_music()
	game_over.emit()
	get_tree().paused = true # Game state: Paused

func win_game():
	play_victory_music()
	game_won.emit()
	get_tree().paused = true # Game state: Paused

func reset_game():
	coins = 0
	if has_node("VictoryMusicPlayer"):
		get_node("VictoryMusicPlayer").queue_free()
	if has_node("DefeatMusicPlayer"):
		get_node("DefeatMusicPlayer").queue_free()
	get_tree().paused = false # Game state: Paused
	get_tree().change_scene_to_file("res://scenes/Level.tscn")
	
