extends Control

onready var picture := $Picture
onready var life := $PanelContainer/HBoxContainer/Life
onready var power := $PanelContainer2/HBoxContainer/Power
onready var pickThisButton := $ActionButtons/PickThis
onready var attackButton := $ActionButtons/Attack
onready var activateButton := $ActionButtons/Activate

var entity: EntityInBoard

func _ready():
	game.entities_controller.connect("entity_updated", self, "_on_Game_update_entity")
	update()
	
	game.connect("set_state", self, "_on_Game_set_state")
	update_buttons()

func _on_Game_update_entity(updated_entity: EntityInBoard):
	if entity == updated_entity:
		update()
		update_buttons()

func update():
	picture.texture = load("res://textures/pictures/" + str(entity.card.def.card_name) + ".png")
	life.text = str(entity.life)
	power.text = str(entity.card.def.attack)
	print("entity ", entity.card.def.card_name, " exhausted = ", entity.exhausted)
	if entity.exhausted:
		rect_rotation = 90
	else:
		rect_rotation = 0
	print("rect_rotation ", rect_rotation)
		
func _on_PickThisButton_pressed():
	game.pick_target(entity)

func _on_AttackButton_pressed():
	game.attack(entity)

func _on_ActivateButton_pressed():
	game.activate(entity)

func _on_Game_set_state():
	update_buttons()

func update_buttons():
	pickThisButton.visible = game.state().can_pick_target()
	attackButton.visible = game.turn_player_id == entity.controller_player_id and game.state().can_attack() and entity.can_attack()
	activateButton.visible = game.turn_player_id == entity.controller_player_id and game.state().can_activate() and entity.can_activate()
