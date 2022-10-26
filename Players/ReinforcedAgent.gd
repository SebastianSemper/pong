extends AbstractAgent

func _get_next_state(frame):
	return $tf._process_image(frame)

