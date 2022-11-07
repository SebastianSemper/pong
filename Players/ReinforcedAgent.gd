extends AbstractAgent

func _get_next_state(frame):
	var result = $tf._process_image(frame)
	return result

