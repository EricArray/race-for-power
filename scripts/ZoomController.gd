extends Node

signal zoom_card(control, card)
signal hide_zoom_card()

func zoom_card(control: Control, def: CardDef):
	emit_signal("zoom_card", control, def)

func hide_zoom_card():
	emit_signal("hide_zoom_card")
