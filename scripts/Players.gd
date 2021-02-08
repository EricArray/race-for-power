class_name Players
extends Node

enum PlayerId {
	P1 = 0
	P2 = 1
}

const EACH := [PlayerId.P1, PlayerId.P2]

static func name(player_id: int) -> String:
	var map := {
		PlayerId.P1: "Player 1",
		PlayerId.P2: "Player 2",
	}
	return map[player_id]

static func opponent(player_id: int) -> int:
	var map := {
		PlayerId.P1: PlayerId.P2,
		PlayerId.P2: PlayerId.P1,
	}
	return map[player_id]
