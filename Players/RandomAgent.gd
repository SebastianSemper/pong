extends AbstractAgent

func _get_next_state(frame):
	return randi() % 3 - 1

