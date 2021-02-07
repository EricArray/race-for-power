extends Control

onready var picture := $Picture
onready var life := $PanelContainer/Life
onready var power := $PanelContainer2/Power

var entity: EntityInBoard

func _ready():
	game.connect("update_entity", self, "_on_Game_update_entity")
	update()

func _on_Game_update_entity(updated_entity: EntityInBoard):
	if entity == updated_entity:
		update()

func update():
	picture.texture = load("res://textures/pictures/" + str(entity.def.card_name) + ".png")
	life.text = str(entity.life)
	power.text = str(entity.def.power)


func _on_Button_pressed():
	entity.life -= 1
	game.update_entity(entity)
