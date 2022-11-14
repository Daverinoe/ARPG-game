extends Spatial

enum State {STATE_MOVE, STATE_INTERACT, STATE_LOCKED, STATE_DEAD}

var starting_state : int = State.STATE_MOVE
var current_state : int

func _ready():
	change_state(starting_state)
	
	# Set level reference
	Global.level_reference = self

func change_state(new_state : int):
	current_state = new_state
