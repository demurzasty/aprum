## A multithreaded task dispatcher designed to efficiently distribute tasks across multiple threads.
extends Node
class_name Dispatcher

## Thread count to create.
## Set to 0 to use all CPU cores available.
@export var thread_count := 0

# Thread count really used to create thread pool.
var _use_thread_count := 0

# A queue of tasks to be executed by the threads.
var _queue: Array = []

#  A mutex to synchronize access to the task queue by different threads.
var _available := Semaphore.new()

# A mutex used to notify worker that a new task has become available.
var _run_mutex := Mutex.new()

# Queue mutex to prevent manipulate with task queue on same time.
var _queue_mutex := Mutex.new()

# Active workers container.
var _workers: Array[Thread] = []

# An atomic (in mind) variable indicating to the workers to keep running. 
var _running := true

func post(callable: Callable, params: Array = []) -> void:
	_queue_mutex.lock()
	_queue.push_back([callable, params])
	_queue_mutex.unlock()

	_available.post()

func _ready() -> void:
	_use_thread_count = thread_count if thread_count > 0 else OS.get_processor_count()

	_workers.resize(_use_thread_count)
	for i in range(_use_thread_count):
		_workers[i] = Thread.new()
		_workers[i].start(_worker)

func _exit_tree() -> void:
	_run_mutex.lock()
	_running = false
	_run_mutex.unlock()

	for worker in _workers:
		_available.post()
	
	for worker in _workers:
		worker.wait_to_finish()

func _worker() -> void:
	while true:
		_available.wait()

		_run_mutex.lock()
		var should_exit := not _running
		_run_mutex.unlock()

		if should_exit:
			break
		
		_queue_mutex.lock()
		var task := _queue.pop_front()
		_queue_mutex.unlock()

		if task:
			var callable = task[0] as Callable
			var params = task[1] as Array

			callable.callv(params)
