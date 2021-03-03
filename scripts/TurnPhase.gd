class_name TurnPhase
extends Reference

const BEGIN_PHASE := 1
const POWER_PHASE := 2
const MAIN_PHASE := 3
const ATTACK_PHASE := 4
const RECOVER_PHASE := 5

static func name(turn_phase: int) -> String:
	var NAMES := {
		BEGIN_PHASE: "Begin phase",
		POWER_PHASE: "Power phase",
		MAIN_PHASE: "Main phase",
		ATTACK_PHASE: "Attack phase",
		RECOVER_PHASE: "Recover phase",
	}
	return NAMES[turn_phase]

static func next(turn_phase: int) -> int:
	var NEXT := {
		BEGIN_PHASE: POWER_PHASE,
		POWER_PHASE: MAIN_PHASE,
		MAIN_PHASE: ATTACK_PHASE,
		ATTACK_PHASE: RECOVER_PHASE,
		RECOVER_PHASE: BEGIN_PHASE,
	}
	return NEXT[turn_phase]
