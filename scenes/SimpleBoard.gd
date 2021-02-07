extends Control

onready var cards_container := $Hand/VBoxContainer/Cards
onready var entities_container := $Entities/VBoxContainer/GridContainer
onready var cards_in_deck := $PlayerState/VBoxContainer/HBoxContainer2/CardsInDeck
onready var player_power := $TurnPhase/VBoxContainer/HBoxContainer/Power
onready var player_elements := $TurnPhase/VBoxContainer/PlayerElements
onready var button_next_phase := $PlayerState/VBoxContainer/NextPhase
onready var label_turn_phase := $TurnPhase/VBoxContainer/TurnPhase
onready var log_container := $Log/VBoxContainer

onready var card_view = $CardVIew
onready var card_view_power_cost = $CardVIew/VBoxContainer/HBoxContainer/PowerCost
onready var card_view_card_name = $CardVIew/VBoxContainer/HBoxContainer/CardName
onready var card_view_element_lvl_container = $CardVIew/VBoxContainer/HBoxContainer/ElementLvlContainer
onready var card_view_picture = $CardVIew/VBoxContainer/Picture
onready var card_view_description = $CardVIew/VBoxContainer/Description
onready var card_view_entity_stats = $CardVIew/VBoxContainer/EntityStats
onready var card_view_attack = $CardVIew/VBoxContainer/EntityStats/Attack
onready var card_view_life = $CardVIew/VBoxContainer/EntityStats/Life

var EntityView = preload("res://scenes/EntityView.tscn")

var element_textures := {
	fire = preload("res://textures/icons/element-icon-fire.png"),
	air = preload("res://textures/icons/element-icon-air.png"),
	water = preload("res://textures/icons/element-icon-water.png"),
	earth = preload("res://textures/icons/element-icon-earth.png"),
}

func _ready():
	game.connect("set_hand", self, "_on_Game_set_hand")
	_on_Game_set_hand()
	
	game.connect("set_deck", self, "_on_Game_set_deck")
	_on_Game_set_deck()
	
	game.connect("set_player_state", self, "_on_Game_set_player_state")
	_on_Game_set_player_state()
	
	game.connect("set_entities", self, "_on_Game_set_entities")
	_on_Game_set_entities()
	
	game.connect("set_state", self, "_on_Game_set_state")
	_on_Game_set_state()
	
	game.connect("log_message", self, "_on_Game_log_message")

func can_play_card(card: Card):
	return game.player_state.can_play(card.def) and game.state.can_play_cards_in_hand()

func _on_Game_set_hand():
	for child in cards_container.get_children():
		cards_container.remove_child(child)
		child.queue_free()
	
	for card in game.cards_in_hand:
		var card_button := Button.new()
		card_button.align = Button.ALIGN_LEFT
		card_button.disabled = not can_play_card(card)
		card_button.hint_tooltip = card.def.build_description()
		card_button.connect("pressed", self, "_on_play_card", [card])
		card_button.connect("mouse_entered", self, "zoom_card", [card.def])
		card_button.connect("mouse_exited", self, "hide_zoom_card")
		
		var text := RichTextLabel.new()
		text.anchor_right = 1
		text.anchor_bottom = 1
		text.margin_left = 4
		text.margin_top = 3
		text.bbcode_enabled = true
		var bbcode_text : String = \
			"[color=#ffff00](" + str(card.def.power_cost)
		for element in ["fire", "air", "water", "earth"]:
			for i in range(card.def.element_lvl[element]):
				bbcode_text += "[img]res://textures/icons/element-icon-" + element + ".png[/img]"
		bbcode_text += ") [/color]" + card.def.card_name
		text.bbcode_text = bbcode_text
		text.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card_button.add_child(text)
			
		cards_container.add_child(card_button)

func _on_Game_set_deck():
	cards_in_deck.text = str(game.cards_in_deck.size())

func _on_Game_set_player_state():
	player_power.text = str(game.player_state.power + game.player_state.temporal_power)
	
	for child in player_elements.get_children():
		child.queue_free()
		player_elements.remove_child(child)
	
	for element in ["fire", "air", "water", "earth"]:
		for i in range(game.player_state.element_lvl[element]):
			var tex = TextureRect.new()
			tex.texture = element_textures[element]
			player_elements.add_child(tex)
	
	for i in cards_container.get_child_count():
		var card_button = cards_container.get_child(i)
		var card = game.cards_in_hand[i]
		card_button.disabled = not can_play_card(card)

func _on_play_card(card: Card):
	hide_zoom_card()
	game.play_card_in_hand(card)

func zoom_card(def: CardDef):
	card_view.visible = true
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
	
func hide_zoom_card():
	card_view.visible = false

func _on_Game_set_entities():
	for child in entities_container.get_children():
		cards_container.remove_child(child)
		child.queue_free()
	
	for entity in game.entities_in_board:
		var entity_view = EntityView.instance()
		entity_view.entity = entity
		entity_view.connect("mouse_entered", self, "zoom_card", [entity.def])
		entity_view.connect("mouse_exited", self, "hide_zoom_card")
		entities_container.add_child(entity_view)

func _on_Game_set_state():
	for i in cards_container.get_child_count():
		var card_button = cards_container.get_child(i)
		var card = game.cards_in_hand[i]
		card_button.disabled = not can_play_card(card)
	
	match game.turn_phase:
		TurnPhase.MAIN_PHASE:
			label_turn_phase.text = "Main phase"
		TurnPhase.ATTACK_PHASE:
			label_turn_phase.text = "Attack phase"
		TurnPhase.RECOVER_PHASE:
			label_turn_phase.text = "Recover phase"

	button_next_phase.disabled = not game.state.can_go_to_next_phase()
	
func _on_NextPhase_pressed():
	game.go_to_next_phase()


func _on_Hand_sort_children():
	$Hand.rect_size = $Hand.rect_min_size

func _on_Game_log_message(message: String):
	var replaced_message = log_container.get_child(0)
	log_container.remove_child(replaced_message)
	replaced_message.text = message
	log_container.add_child(replaced_message)
