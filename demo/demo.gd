extends Node2D

@onready var _dispatcher := $Dispatcher as Dispatcher

func _ready() -> void:
	var token := Token.new()

	_dispatcher.post(job, [token])

	await get_tree().create_timer(5.0).timeout

	token.cancel()

func job(token: Token) -> void:
	# Something CPU intensive.
	for i in range(50):
		if token.is_cancelled():
			print("Cancelled!")
			return
		
		print("fib(%d) = %d" % [i, fibonacci(i)])
	
	print("Done!")

func fibonacci(n: int) -> int:
	if n <= 1:
		return n
	else:
		return fibonacci(n - 1) + fibonacci(n - 2)
