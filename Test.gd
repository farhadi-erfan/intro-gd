extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$IntroController.connect("intro_ended", self, "on_intro_finished")
	$Button.connect("pressed", self, "on_btn_pressed")
	$IntroController.start()


func on_intro_finished(intro_name):
	print("intro ", intro_name, " finished!")

func on_btn_pressed():
	$IntroController.reset()
	$IntroController.start()
