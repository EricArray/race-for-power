extends PanelContainer

onready var cards_container := $VBoxContainer2/VBoxContainer/CardsInHand
onready var cards_in_deck := $VBoxContainer2/HBoxContainer4/HBoxContainer2/CardsInDeck
onready var discard_pile := $VBoxContainer2/HBoxContainer4/HBoxContainer3/DiscardPile
onready var player_power := $VBoxContainer2/HBoxContainer/Power
onready var player_elements := $VBoxContainer2/PlayerElements

var element_textures := {
	fire = preload("res://textures/icons/element-icon-fire.png"),
	air = preload("res://textures/icons/element-icon-air.png"),
	water = preload("res://textures/icons/element-icon-water.png"),
	earth = preload("res://textures/icons/element-icon-earth.png"),
}

func _ready():
	game.connect("set_state", self, "_on_Game_set_state")
	_on_Game_set_state()

	cards_controller.connect("hand_updated", self, "_on_Game_set_hand")
	_on_Game_set_hand()

	cards_controller.connect("deck_updated", self, "_on_Game_set_deck")
	_on_Game_set_deck()

	cards_controller.connect("discard_pile_updated", self, "_on_Game_set_discard_pile")
	_on_Game_set_discard_pile()

	game.player_state.connect("updated", self, "_on_Game_player_state_updated")
	_on_Game_player_state_updated()

func can_play_card(card: Card):
	return game.player_state.can_play(card.def) and game.state.can_play_cards_in_hand()

func _on_Game_set_state():
	for i in cards_container.get_child_count():
		var card_button = cards_container.get_child(i)
		var card = cards_controller.cards_in_hand[i]
		card_button.disabled = not can_play_card(card)

func _on_Game_set_hand():
	for child in cards_container.get_children():
		cards_container.remove_child(child)
		child.queue_free()

	for card in cards_controller.cards_in_hand:
		var card_button := Button.new()
		card_button.align = Button.ALIGN_LEFT
		card_button.disabled = not can_play_card(card)
		card_button.hint_tooltip = card.def.build_description()
		card_button.connect("pressed", self, "_on_play_card", [card])
		card_button.connect("gui_input", self, "_on_card_in_hand_gui_input", [card])
		card_button.connect("mouse_entered", zoom_controller, "zoom_card", [card_button, card.def])
		card_button.connect("mouse_exited", zoom_controller, "hide_zoom_card")

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
	
	rect_size.y = 0

func _on_play_card(card: Card):
	if game.state.can_play_cards_in_hand():
		zoom_controller.hide_zoom_card()
		game.play_card_in_hand(card)

func _on_card_in_hand_gui_input(event: InputEvent, card: Card):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed == false:
			if  game.state.can_play_cards_in_hand():
				zoom_controller.hide_zoom_card()
				game.set_trap(card)

func _on_Game_set_deck():
	cards_in_deck.text = str(cards_controller.cards_in_deck.size())

func _on_Game_set_discard_pile():
	discard_pile.text = str(cards_controller.discard_pile.size())

func _on_Game_player_state_updated():
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
		var card = cards_controller.cards_in_hand[i]
		card_button.disabled = not can_play_card(card)
