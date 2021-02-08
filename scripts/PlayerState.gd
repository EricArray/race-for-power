class_name PlayerState
extends Reference

signal updated()

var power: int = 5
var temporal_power: int = 0
var power_per_turn: int = 5

var element_lvl := {
	fire = 0,
	air = 0,
	water = 0,
	earth = 0,
}
var temporal_element_lvl := {
	fire = 0,
	air = 0,
	water = 0,
	earth = 0,
}

func reset():
	power = 5
	temporal_power = 0
	power_per_turn = 5

	element_lvl = {
		fire = 0,
		air = 0,
		water = 0,
		earth = 0,
	}
	temporal_element_lvl = {
		fire = 0,
		air = 0,
		water = 0,
		earth = 0,
	}


func total_power() -> int:
	return power + temporal_power

func gain_power(power_gain: int):
	power += power_gain
	emit_signal("updated")

func try_spend_power(power_to_spend: int) -> bool:
	if total_power() >= power_to_spend:
		if temporal_power >= power_to_spend:
			temporal_power -= power_to_spend
		else:
			power -= power_to_spend - temporal_power
			temporal_power = 0
		emit_signal("updated")
		return true
	else:
		return false

func gain_temporal_power(temporal_power_gain: int):
	temporal_power += temporal_power_gain
	emit_signal("updated")
	
func waste_temporal_power():
	temporal_power = 0
	emit_signal("updated")

func total_element_lvl(element: String) -> int:
	return element_lvl[element] + temporal_element_lvl[element]

func inc_power_per_turn(diff):
	power_per_turn += diff
	emit_signal("updated")
	
func dec_power_per_turn(diff):
	power_per_turn -= diff

func inc_element_lvl(element: String, lvls: int):
	element_lvl[element] += lvls
	emit_signal("updated")
	
func dec_element_lvl(element: String, lvls: int):
	element_lvl[element] -= lvls
	emit_signal("updated")

func can_play(def: CardDef) -> bool:
	return def.power_cost <= total_power() and \
		def.element_lvl["fire"] <= total_element_lvl("fire") and \
		def.element_lvl["air"] <= total_element_lvl("air") and \
		def.element_lvl["water"] <= total_element_lvl("water") and \
		def.element_lvl["earth"] <= total_element_lvl("earth")
