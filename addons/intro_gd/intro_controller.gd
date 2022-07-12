extends Node2D

signal start_intro
signal intro_ended

var TipClass = preload("res://addons/intro_gd/intro_tip.gd")

export var intro_name: String

var intros
var has_played = false
var current_tip = -1
var tips_len = 0

func _ready():
	var intro_data = File.new()
	if not intro_data.file_exists("user://intro_data.save"):
		intro_data.open("user://intro_data.save", File.WRITE)
		intro_data.close()
	
	intro_data.open("user://intro_data.save", File.READ)
	intros = parse_json(intro_data.get_line())
	if intros == null:
		intros = {}
	if intros.has(intro_name):
		has_played = intros[intro_name]

	self.connect("start_intro", self, "start")
	
	$Node2D/VSplitContainer/HSplitContainer/Next.connect("pressed", self, "play_next")
	$Node2D/VSplitContainer/HSplitContainer/Prev.connect("pressed", self, "play_prev")
	
	for c in self.get_children():
		if c is TipClass:
			tips_len += 1
	
	start()

func start():
	$Node2D.visible = true
	play_next()
	$Node2D/VSplitContainer/HSplitContainer/Prev.disabled = true

func play_next():
	if not has_played and current_tip < tips_len - 1:
		hide_last_tip()
		current_tip += 1
		show_tip(self.get_children()[current_tip])
		if current_tip == tips_len - 1:
			$Node2D/VSplitContainer/HSplitContainer/Next.text = 'End'
		
		if $Node2D/VSplitContainer/HSplitContainer/Prev.disabled:
			$Node2D/VSplitContainer/HSplitContainer/Prev.disabled = false
	else:
		$Node2D.visible = false
		_before_end()

func play_prev():
	if current_tip > 0:
		hide_last_tip()
		current_tip -= 1
		show_tip(self.get_children()[current_tip])
		if current_tip == 0:
			$Node2D/VSplitContainer/HSplitContainer/Prev.disabled = true

func hide_last_tip():
	var c = self.get_children()[current_tip]
	if c is TipClass:
		c.visible = false

func show_tip(tip):
	tip.visible = true
	$Node2D/VSplitContainer/Label.text = tip.text
	tip.refresh_text_pos($Node2D/VSplitContainer.get_rect().size.y)
	$Node2D.position = tip.text_pos


func _before_end():
	hide_last_tip()
	has_played = true
	intros[intro_name] = has_played
	var intro_data = File.new()
	intro_data.open("user://intro_data.save", File.WRITE)
	intro_data.store_line(to_json(intros))
	intro_data.close()
