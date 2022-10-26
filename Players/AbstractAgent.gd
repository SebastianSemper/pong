extends Node
class_name AbstractAgent

var current_state = 0

func get_next_state(frame):
	current_state = _get_next_state(frame)

func _get_next_state(frame):
	# must be implemented by implementations
	pass

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
