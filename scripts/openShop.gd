extends Button

var ins
var removeAfter = false

func _on_Button2_button_down():
	var shop = load("res://assets/scenes/shop.tscn")
	ins = shop.instance()
	ins.position.x = ProjectSettings.get_setting('display/window/size/width') * -1
	$Tween.interpolate_property(ins, 'position:x', ins.position.x, 0, 2, Tween.TRANS_QUAD)
	ins.get_node("Control/Button").connect("button_down", self, "slideBack")
	get_tree().get_root().get_node("/root/Node2D").add_child(ins)
	$Tween.start()

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		slideBack()

func slideBack():
	removeAfter = true
	$Tween.interpolate_property(ins, 'position:x', ins.position.x, ProjectSettings.get_setting('display/window/size/width') * -1, 2, Tween.TRANS_QUAD)
	$Tween.start()
	
func _on_Tween_tween_all_completed():
	if removeAfter:
		ins.queue_free()
