extends Control

onready var cards_container := $Hand/VBoxContainer/Cards
onready var entities_container := $Entities/VBoxContainer/GridContainer

var EntityView = preload("res://scenes/EntityView.tscn")

func _ready():
	game.connect("set_hand", self, "_on_Game_set_hand")
	_on_Game_set_hand()
	
	game.connect("set_entities", self, "_on_Game_set_entities")

func _on_Game_set_hand():
	for child in cards_container.get_children():
		child.queue_free()
	
	for card in game.cards_in_hand:
		var card_button := Button.new()
		card_button.text = card.def.card_name
		card_button.connect("pressed", self, "_on_play_card", [card])
		cards_container.add_child(card_button)
		
func _on_play_card(card: Card):
	game.play_card_in_hand(card)

func _on_Game_set_entities():
	for child in entities_container.get_children():
		child.queue_free()
	
	for entity in game.entities_in_board:
		var entity_view = EntityView.instance()
		entity_view.entity = entity
		entities_container.add_child(entity_view)
