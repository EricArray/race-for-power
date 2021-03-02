class_name EntityInBoard
extends Reference

var controller_player_id: int
var card
var def
var life: int
var exhausted: bool
var control: Control

func _init(controller_player_id: int, card):
	self.controller_player_id = controller_player_id
	self.card = card
	self.def = card.def
	self.life = card.def.life
	self.exhausted = false
	self.control = null
