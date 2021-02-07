extends PanelContainer

onready var card_view_power_cost = $VBoxContainer/HBoxContainer/PowerCost
onready var card_view_card_name = $VBoxContainer/HBoxContainer/CardName
onready var card_view_element_lvl_container = $VBoxContainer/HBoxContainer/ElementLvlContainer
onready var card_view_picture = $VBoxContainer/Picture
onready var card_view_description = $VBoxContainer/Description
onready var card_view_entity_stats = $VBoxContainer/EntityStats
onready var card_view_attack = $VBoxContainer/EntityStats/Attack
onready var card_view_life = $VBoxContainer/EntityStats/Life

func _ready():
	cards_controller.connect("zoom_card", self, "_on_zoom_card")
	cards_controller.connect("hide_zoom_card", self, "_on_hide_zoom_card")

func _on_zoom_card(control: Control, def: CardDef):
	visible = true
	
	var rect := control.get_global_rect()
	var center := rect.position.x + rect.size.x / 2
	if center <= get_viewport_rect().size.x:
		anchor_left = 1
		anchor_right = 1
		margin_left = -250
		margin_right = -50
	else:
		anchor_left = 0
		anchor_right = 0
		margin_left = 50
		margin_right = 250
		
	card_view_power_cost.text = str(def.power_cost)
	card_view_card_name.text = def.card_name
	for element in card_view_element_lvl_container.get_children():
		element.queue_free()
		card_view_element_lvl_container.remove_child(element)
	for element in ["fire", "air", "water", "earth"]:
		for i in range(def.element_lvl[element]):
			var tex := TextureRect.new()
			tex.texture = load("res://textures/icons/element-icon-" + element + ".png")
			card_view_element_lvl_container.add_child(tex)
	card_view_picture.texture = load("res://textures/pictures/" + def.card_name + ".png")
	card_view_description.bbcode_text = def.build_description()

	if def.card_type == CardDef.CardType.ENTITY:
		card_view_entity_stats.visible = true
		card_view_attack.text = "Attack: " + str(def.attack)
		card_view_life.text = "Life: " + str(def.life)
	else:
		card_view_entity_stats.visible = false

func _on_hide_zoom_card():
	visible = false

