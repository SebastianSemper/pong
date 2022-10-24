extends Player

var agent
var frame_mutex
var frame_semaphore
var frame_thread
var frame_thread_stop
var current_frame

var current_state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	frame_mutex = Mutex.new()
	frame_semaphore = Semaphore.new()
	frame_thread = Thread.new()
	frame_thread_stop = false
	frame_thread.start(self, "_process_frame")
	current_frame = Image.new()
	current_frame.create(64, 64, false, Image.FORMAT_L8)
	
func init(_character, _agent):
	._abstractInit(_character)
	agent = _agent

func _receive_frame(frame):
	frame_mutex.lock()
	current_frame.copy_from(frame)
	frame_mutex.unlock()
	frame_semaphore.post()
	
func _process_frame():
	while true:
		frame_semaphore.wait()
		
		frame_mutex.lock()
		var should_stop = frame_thread_stop 
		frame_mutex.unlock()
		
		if should_stop:
			break
			
		frame_mutex.lock()
		current_state = agent.get_next_state(current_frame)
		frame_mutex.unlock()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state == -1:
		emit_signal("move_down")
	elif current_state == +1:
		emit_signal("move_up")

func _exit_tree():
	frame_mutex.lock()
	frame_thread_stop = true
	frame_mutex.unlock()	
	frame_semaphore.post()
	frame_thread.wait_to_finish()
