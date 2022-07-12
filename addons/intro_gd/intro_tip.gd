extends Polygon2D

export var text: String
export var text_pos = Vector2(-1, -1) 

var min_x 
var max_x 
var min_y 
var max_y
onready var width = get_viewport().get_visible_rect().size.x
onready var height = get_viewport().get_visible_rect().size.y

func _ready():
	self.invert_enable = true
	self.color = Color(0, 0, 0, 0.8)
	self.visible = false
	
	var x_s = []
	var y_s = []
	for p in self.polygon:
		x_s.append(p.x)
		y_s.append(p.y)
	
	
	
	min_x = x_s.min()
	max_x = x_s.max()
	min_y = y_s.min()
	max_y = y_s.max()
	self.invert_border = [min_x, width - max_x, min_y, height - max_y].max() + 50

func refresh_text_pos(h):
	if text_pos == Vector2(-1, -1):
		if h + 50 < height - max_y:
			text_pos = Vector2((min_x + max_x) / 2, min_y + 150)
		elif h < min_y:
			text_pos = Vector2((min_x + max_x) / 2, max_y + 150)
		else:
			text_pos = Vector2((min_x + max_x) / 2, (min_y + max_y) / 2)
	else:
		return text_pos
