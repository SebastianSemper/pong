# https://coolors.co/22223b-4a4e69-9a8c98-c9ada7-f2e9e4
# sound
# schweif
# richtung

extends Node

var character_scene = preload("res://Character.tscn")
var left_char = character_scene.instance()
var right_char = character_scene.instance()

var field_scene = preload("res://Field.tscn")
var top_field = field_scene.instance()
var bottom_field = field_scene.instance()

var left_score = preload("res://Score.tscn").instance()
var right_score = preload("res://Score.tscn").instance()

var ball_scene = preload("res://Ball.tscn")
var ball

var round_running = 0

var human_scene = preload("res://Players/Human.tscn")
var ai_scene = preload("res://Players/AI.tscn")
var random_ai = preload("res://Players/RandomAgent.tscn")
var physics_ai = preload("res://Players/PhysicsAgent.tscn")
var reinforced_ai = preload("res://Players/ReinforcedAgent.tscn")

var left_player
var right_player

var frame_mutex
var frame_semaphore
var frame_thread
var frame_thread_stop
var current_frame
var frame_time = 0.01
var time_since_last_frame = 0
signal frame_ready(frame)

func _make_player(character, type):
	var player 
	match type:
		"physics":
			player = ai_scene.instance()
			var agent = physics_ai.instance()
			agent.scene = self
			agent.character = character
			player.init(character, agent)
		"random":
			player = ai_scene.instance()
			player.init(character, random_ai.instance())
		"reinforced":
			player = ai_scene.instance()
			player.init(character, reinforced_ai.instance())
		"human":
			player = human_scene.instance()
			player.init(character)
	self.connect("frame_ready", player, "_receive_frame")
	add_child(player)
	return player

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Engine.time_scale = 2.0
	
	left_char.init(
		Vector2(20,300),
		Vector2(20,600-70),
		"move_left_down",
		"move_left_up"
		)
	right_char.init(
		Vector2(780,300),
		Vector2(20,600-70),
		"move_right_down",
		"move_right_up"
	)
	add_child(left_char)
	add_child(right_char)
	
	left_player = _make_player(left_char, "physics")
	right_player = _make_player(right_char, "physics")
	
	top_field.init(Vector2(400, 20), Vector2(360, 3))
	bottom_field.init(Vector2(400, 530), Vector2(360, 3))
	add_child(top_field)
	add_child(bottom_field)
		
	left_score.init(Vector2(350, 535))
	right_score.init(Vector2(450, 535))
	add_child(left_score)
	add_child(right_score)
	
	frame_mutex = Mutex.new()
	frame_semaphore = Semaphore.new()
	frame_thread = Thread.new()
	frame_thread_stop = false
	frame_thread.start(self, "_send_current_frame")
	
	_new_ball()
	
func _new_ball():
	ball = ball_scene.instance()
	add_child(ball)
	ball.init(Vector2(400, 0.5 * (20 + 530)))

func _on_Bell_timeout():
	_start_round()
	$Bell.stop()

func _start_round():
	ball.shoot()
	round_running = 1

func _end_round(winner):
	if winner == -1:
		left_score.score()
	elif winner == +1:
		right_score.score()
	round_running = 0
	ball.queue_free()
	
	_new_ball()
	$Bell.start()

func _process(delta):
	if round_running:
		if ball.position.x < 0:
			_end_round(+1)
		if ball.position.x > 800:
			_end_round(-1)
		time_since_last_frame += delta
		if time_since_last_frame > frame_time:
			frame_semaphore.post()
			time_since_last_frame = 0
		
func _send_current_frame():
	while true:
		frame_semaphore.wait()
		
		frame_mutex.lock()
		var should_stop = frame_thread_stop 
		frame_mutex.unlock()
		
		if should_stop:
			break
		
		var raw_img = get_viewport().get_texture().get_data()
		raw_img.convert(Image.FORMAT_L8)
		var cropped_img = raw_img.get_rect(Rect2(0,70,800,510))
		cropped_img.resize(
			64, 64, Image.INTERPOLATE_BILINEAR
		)
		emit_signal("frame_ready", cropped_img)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			if not round_running:
				_start_round()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

func _exit_tree():
	frame_mutex.lock()
	frame_thread_stop = true
	frame_mutex.unlock()	
	frame_semaphore.post()
	frame_thread.wait_to_finish()


