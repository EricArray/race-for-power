extends Node

var imp := load_imp()
var warlock := load_warlock()
var surge_of_power := load_surge_of_power()
var fireball := load_fireball()
var firestorm := load_firestorm()

var polliwog := load_polliwog()
var hydrothermal_vents := load_hydrothermal_vents()
var freeze := load_freeze()
var exploration := load_exploration()
var blue_dragon := load_blue_dragon()

func load_imp() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.ENTITY
	def.card_name = "Imp"
	def.element_lvl["fire"] = 1
	def.type = "Demon"
	def.description = "Insignificat fire being."
	def.power_cost = 1
	def.life = 1
	def.attack = 1
	def.on_destroyed = GainPower.new(2)
	return def

func load_warlock() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.ENTITY
	def.card_name = "Warlock"
	def.type = "Human"
	def.description = "A lesser magician with devotion to fire."
	def.power_cost = 2
	def.life = 3
	def.attack = 1
	def.static_effect = IncElementLvl.new("fire", 1)
	return def

func load_surge_of_power() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.INSTANT
	def.card_name = "Surge of Power"
	def.element_lvl["fire"] = 3
	def.description = "UNLIMITED POWER"
	def.power_cost = 0
	def.on_play = GainTemporalPower.new(5)
	return def

func load_fireball() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.INSTANT
	def.card_name = "Fireball"
	def.element_lvl["fire"] = 1
	def.description = "The most basic harming spell."
	def.power_cost = 1
	def.on_play = Target.new(DealDamage.new(2))
	return def

func load_firestorm() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.INSTANT
	def.card_name = "Firestorm"
	def.element_lvl["fire"] = 3
	def.description = "Double edged crowd control"
	def.power_cost = 5
	def.on_play = EveryEntity.new(DealDamage.new(2))
	return def

func load_polliwog() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.ENTITY
	def.card_name = "Polliwog"
	def.type = "Monster"
	def.description = "Squishy water elemental."
	def.power_cost = 1
	def.life = 1
	def.attack = 0
	def.static_effect = IncElementLvl.new("water", 1)
	return def

func load_hydrothermal_vents() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.ENTITY
	def.card_name = "Hydrothermal Vents"
	def.type = "Monster"
	def.description = "Source of underwater life."
	def.power_cost = 2
	def.life = 5
	def.attack = 0
	def.static_effect = PowerPerTurn.new(2)
	return def

func load_blue_dragon() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.ENTITY
	def.card_name = "Blue Dragon"
	def.element_lvl["water"] = 2
	def.type = "Monster"
	def.description = "A dragon that is blue."
	def.power_cost = 4
	def.life = 4
	def.attack = 4
	return def

func load_freeze() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.INSTANT
	def.card_name = "Freeze"
	def.element_lvl["water"] = 1
	def.description = "Fight me if you can."
	def.power_cost = 2
	def.on_play = Target.new(Exhaust.new())
	return def

func load_exploration() -> CardDef:
	var def = CardDef.new()
	def.card_type = CardDef.CardType.INSTANT
	def.card_name = "Exploration"
	def.element_lvl["water"] = 2
	def.description = "Find new sources of knowledge."
	def.power_cost = 3
	def.on_play = DrawCards.new(2)
	return def
