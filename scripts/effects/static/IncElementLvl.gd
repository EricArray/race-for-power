class_name IncElementLvl
extends StaticEffect

var element: String
var lvl: int

func _init(element: String, lvl: int):
	self.element = element
	self.lvl = lvl

func build_description() -> String:
	var s := ""
	for i in range(lvl):
		s += "[img]res://textures/icons/element-icon-" + element + ".png[/img]"
	return s
	
func apply():
	game.player(Players.HARDCODED_P1_BEFORE_MULTIPLAYER).inc_element_lvl(element, lvl)

func undo():
	game.player(Players.HARDCODED_P1_BEFORE_MULTIPLAYER).dec_element_lvl(element, lvl)
