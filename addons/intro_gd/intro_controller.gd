extends Node2D

signal intro_ended(intro_name)

var TipClass = preload("res://addons/intro_gd/intro_tip.gd")

export var intro_name: String
export var theme: Theme
export var label_class_path: String

var has_played = false

var intros
var current_tip = -1
var tips_len = 0

var node_2d_controllers_container = Node2D.new()
var vsplit = VSplitContainer.new()
var hsplit = HSplitContainer.new()
var prev_btn = Button.new()
var next_btn = Button.new()
var label = Label.new()

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
	
	var LabelClass = load(label_class_path)
	if LabelClass != null and LabelClass is Label:
		label = LabelClass.new()
	
	hsplit.add_child(prev_btn)
	hsplit.add_child(next_btn)
	vsplit.add_child(label)
	vsplit.add_child(hsplit)
	node_2d_controllers_container.add_child(vsplit)
	self.add_child(node_2d_controllers_container)
	
	vsplit.theme = self.theme
	node_2d_controllers_container.visible = false
	next_btn.text = 'Next>'
	prev_btn.text = '<Prev'
	
	next_btn.connect("pressed", self, "play_next")
	prev_btn.connect("pressed", self, "play_prev")
	
	for c in self.get_children():
		if c is TipClass:
			tips_len += 1

func reset():
	if has_played:
		has_played = false
		current_tip = -1

func start():
	if node_2d_controllers_container.visible:
		return
	node_2d_controllers_container.visible = true
	play_next()
	prev_btn.disabled = true

func play_next():
	if not has_played and current_tip < tips_len - 1:
		hide_last_tip()
		current_tip += 1
		show_tip(self.get_children()[current_tip])
		if current_tip == tips_len - 1:
			next_btn.text = 'End'
		
		if prev_btn.disabled:
			prev_btn.disabled = false
	else:
		node_2d_controllers_container.visible = false
		_before_end()
		emit_signal("intro_ended", intro_name)

func play_prev():
	if current_tip > 0:
		hide_last_tip()
		current_tip -= 1
		if next_btn.text == 'End':
			next_btn.text = 'Next>'
		show_tip(self.get_children()[current_tip])
		if current_tip == 0:
			prev_btn.disabled = true

func hide_last_tip():
	var c = self.get_children()[current_tip]
	if c is TipClass:
		c.visible = false

func show_tip(tip):
	tip.visible = true
	label.text = tip.text
	#TODO - change for persian label
	tip.refresh_text_pos(vsplit.get_rect().size.y)
	node_2d_controllers_container.position = tip.text_pos


func _before_end():
	hide_last_tip()
	has_played = true
	intros[intro_name] = has_played
	var intro_data = File.new()
	intro_data.open("user://intro_data.save", File.WRITE)
	intro_data.store_line(to_json(intros))
	intro_data.close()
