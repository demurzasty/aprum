class_name Token
extends RefCounted

var _cancelled := false
var _mutex := Mutex.new()

## Communicates a request for cancellation.
func cancel() -> void:
    _mutex.lock()
    _cancelled = true
    _mutex.unlock()

## Gets whether cancellation has been requested for this token.
func is_cancelled() -> bool:
    _mutex.lock()
    var cancelled = _cancelled
    _mutex.unlock()

    return cancelled
