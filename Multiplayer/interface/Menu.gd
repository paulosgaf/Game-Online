extends Control

var player_nickname = ""
var player_IP = ""


func _on_Nick_text_changed(new_text):
	player_nickname = new_text
	
func _on_IP_text_changed(new_text):
	player_IP = new_text
	

func _on_CreateButton_pressed():
	if player_nickname == "" or player_IP == "":
		return
	Network.create_server(player_nickname, player_IP)
	_load_game()

func _on_JoinButton_pressed():
	if player_nickname == "" or player_IP == "":
		return
	Network.connect_to_server(player_nickname, player_IP)
	_load_game()

func _load_game():
	get_tree().change_scene('res://Game.tscn')






