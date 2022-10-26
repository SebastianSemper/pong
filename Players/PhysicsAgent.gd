extends AbstractAgent

var character = 0
var ball = 0

func _get_next_state(frame):
	var destination = _bounce_path(
		ball.position, ball.linear_velocity, character.start_position.x
	)
	destination.y = clamp(destination.y, 55, 480)
	return _move_to_y(destination.y)

func _bounce_path(start, direction, target_x):
	var travel_distance = (target_x - start.x) / direction.x
		
	var destination = start + travel_distance * direction
	var bounces = false
	var bounce_distance = 0
	
	# if the ball is moving away from us, we see where it might come from, 
	# given the opponent might reflect it back.
	if travel_distance < 0:
		var opponent_x = -(character.start_position.x - 400) + 400
		var opponent_distance = (opponent_x - start.x) / direction.x
		var bounce_position = start + opponent_distance * direction
		if abs(bounce_position.x - character.start_position.x) > 750:
			var bounce_direction = 1.0 * direction
			bounce_direction.x *= -1
			return _bounce_path(bounce_position, bounce_direction, target_x)
			
	if destination.y < 20:
		bounce_distance = (20 - start.y) / direction.y
		bounces = true
	elif destination.y > 530:
		bounce_distance = (530 - start.y) / direction.y
		bounces = true
	if bounces:
		var bounce_direction = 1.0 * direction
		bounce_direction.y *= -1
		var bounce_position = start + bounce_distance * direction
		return _bounce_path(bounce_position, bounce_direction, target_x)
	else:
		return destination

func _move_to_y(target_y):
	if target_y >= character.position.y:
		return -_draw_bernoulli(_prob_relu(target_y - character.position.y))
	else:
		return +_draw_bernoulli(_prob_relu(character.position.y - target_y))

		
func _prob_relu(x):
	return pow(clamp(x / 35.0, 0, 1), 2)
	
func _draw_bernoulli(x):
	if x == 1:
		return 1
	elif x < rand_range(0, 1):
		return 1
	else:
		return 0 
