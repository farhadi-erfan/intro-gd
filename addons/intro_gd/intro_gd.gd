tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("IntroTip", "Polygon2D", preload("intro_tip.gd"), preload("tip_icon.png"))
	add_custom_type("IntroController", "Node2D", preload("intro_controller.gd"), preload("controller_icon.png"))




func _exit_tree():
	remove_custom_type("IntroTip")
	remove_custom_type("IntroController")
