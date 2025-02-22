extends Control

#FIXME : THE UI DOESNT MATCH THE ACTUAL HEALTH SOMETIMES

onready var heartsUI_full = $HeartUIFull
onready var heartsUI_half = $HeartUIHalf
onready var heartsUI_empty = $HeartUIEmpty

var max_hearts = 10 setget set_max_hearts
var hearts = 10 setget set_hearts

func _ready():
	var _value
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	_value = PlayerStats.connect("health_changed", self, "set_hearts")
	_value = PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	heartsUI_full.rect_size.x = float(hearts / 2) * 14
	heartsUI_half.rect_size.x = ceil(float(hearts) / 2) * 14

func set_hearts(value):
	var rest = (hearts % 2)
	if value < hearts:
		hearts = clamp(value, 0, max_hearts)
		if rest == 0:
			heartsUI_full.rect_size.x = float(value / 2) * 14
			heartsUI_half.rect_size.x = ceil(float(hearts) / 2) * 14
		else:
			heartsUI_half.rect_size.x = ceil(float(hearts) / 2) * 14
			if heartsUI_half.rect_size.x <= heartsUI_full.rect_size.x:
				heartsUI_full.rect_size.x = ceil(float(hearts) / 2) * 14
	else:
		hearts = clamp(value, 0, max_hearts)
		if rest == 0:
			heartsUI_full.rect_size.x = float(value / 2) * 14
			heartsUI_half.rect_size.x = ceil(float(hearts) / 2) * 14
		else:
			heartsUI_half.rect_size.x = ceil(float(hearts) / 2) * 14
			if heartsUI_half.rect_size.x >= heartsUI_full.rect_size.x:
				heartsUI_full.rect_size.x = ceil(float(hearts) / 2) * 14

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	heartsUI_empty.rect_size.x = ceil(float(max_hearts) / 2) * 14
