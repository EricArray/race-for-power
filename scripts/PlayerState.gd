class_name PlayerState
extends Resource

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

func total_power() -> int:
	return power + temporal_power

func gain_power(power_gain: int):
	power += power_gain

func try_spend_power(power_to_spend: int) -> bool:
	if total_power() >= power_to_spend:
		if temporal_power >= power_to_spend:
			temporal_power -= power_to_spend
		else:
			power -= power_to_spend - temporal_power
			temporal_power = 0
		return true
	else:
		return false

func waste_temporal_power():
	temporal_power = 0

func total_element_lvl(element: String) -> int:
	return element_lvl[element] + temporal_element_lvl[element]

func inc_element_lvl(element: String, lvls: int):
	element_lvl[element] += lvls
	
func dec_element_lvl(element: String, lvls: int):
	element_lvl[element] -= lvls

func can_play(def: CardDef) -> bool:
	return def.power_cost <= total_power() and \
		def.element_lvl["fire"] <= total_element_lvl("fire") and \
		def.element_lvl["air"] <= total_element_lvl("air") and \
		def.element_lvl["water"] <= total_element_lvl("water") and \
		def.element_lvl["earth"] <= total_element_lvl("earth")
