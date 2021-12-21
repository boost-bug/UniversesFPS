extends Button


func _on_Button_button_down():
	get_tree().change_scene("res://assets/maps/CrossGray.tscn")

func _on_Button_mouse_entered():
	modulate.a = 0.4

func _on_Button_mouse_exited():
	modulate.a = 1
