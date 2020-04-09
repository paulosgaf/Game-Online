extends Node


func _ready():
	pass # Replace with function body.

#--------------BODY SHAPE TELEPORTE--------------
func _on_Down_body_entered(body):
	body.position = Vector2(body.get_global_position().x, -400)

func _on_Top_body_entered(body):
	body.position = Vector2(body.get_global_position().x, 400)

func _on_Left_body_entered(body):
	body.position = Vector2(550, body.get_global_position().y-512)

func _on_Right_body_entered(body):
	body.position = Vector2(-550, body.get_global_position().y+512)

#--------------AREA SHAPE TELEPORTE--------------
func _on_Down_area_entered(area):
	area.position = Vector2(area.get_global_position().x, -400)
	
func _on_Top_area_entered(area):
	area.position = Vector2(area.get_global_position().x, 400)
	
func _on_Left_area_entered(area):
	area.position = Vector2(550, area.get_global_position().y-512)

func _on_Right_area_entered(area):
	area.position = Vector2(-550, area.get_global_position().y+512)





func _on_Wall_body_entered(body):
	if body.is_in_group('players'):
		body._on_wall = true

func _on_Wall_body_exited(body):
	if body.is_in_group('players'):
		body._on_wall = false
