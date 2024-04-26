# APRUM: Multithreaded Task Dispatcher for Godot 4 

**APRUM** is an addon for the Godot game engine that provides a multithreaded task dispatcher to efficiently distribute tasks across multiple threads. It allows you to offload CPU-intensive tasks from the main thread to improve performance and responsiveness of your Godot applications.

## 🔨 How it works

At the start of the `Dispatcher` node a fixed number of threads are initialized. Tasks to be executed concurrently are submitted to the `Dispatcher`. Submitted tasks are placed into a queue managed by the `Dispatcher`.  

This queue serves as a buffer, holding tasks until there are available threads to execute them. The `Dispatcher` continuously monitors the queue for incoming tasks. When a task becomes available, it assigns it to an idle thread from the pool.  

The assigned thread executes the task's code. This could involve performing calculations, I/O operations, **or any other kind of work that can be parallelized**.

Instead of creating and destroying threads for each task, the `Dispatcher` **reuses existing threads**. This reduces overhead associated with thread creation and teardown.

To ensure thread safety and prevent race conditions, synchronization mechanisms like **mutexes and semaphores** are used. These mechanisms ensure that shared resources are accessed safely by multiple threads.

When the program is shutting down or the `Dispatcher` is no longer needed, the `Dispatcher` ensures that all pending tasks are completed and resources are properly released.

## 📝 Simplicity

As you can see, the code of this project is very simple. It's just the beginning of work on this addon, and over time, I plan to expand it with new multithreaded functionalities.

## 🚀 Features

- **Multithreaded Task Execution:** Distributes tasks across multiple threads to utilize all available CPU cores efficiently.
- **Task Queue Management:** Provides a queue system to manage tasks and their execution order.
- **Easy Integration:** Easily integrate into your Godot projects as an addon.

## 💡 Important Notice

Keep in mind that this project is currently in a work-in-progress state. While we're actively developing and refining it, there are certain aspects that may be incomplete, unstable, or subject to change.

- **Incomplete Features**: Some features of the project may not be fully implemented or may be in various stages of development. As a result, certain functionalities may not work as expected or may be temporarily disabled.

- **Bugs and Issues**: Since the project is still in development, there may be bugs, errors, or issues that have not yet been addressed. We're working diligently to identify and resolve these issues, but your patience and understanding are appreciated.

- **Changes to Design and Functionality**: As we iterate on the project, there may be changes to the design or functionality. We're constantly refining our ideas and incorporating feedback to create the best possible experience for our users.

## 🤝 How You Can Help

- **Feedback**: If you encounter any issues, have suggestions for improvement, or would like to share your thoughts, please don't hesitate to reach out to me.

- **Testing**: Help identify bugs and issues by testing the project and providing feedback on your experience. Your testing efforts can help us improve the project's stability and usability.

## 📦 Installation

1. Download the `aprum` repository.
2. Place the directory `addons/aprum` in the `addons` folder of your Godot project.
3. Enable the addon in your project settings.

## 🎮 Usage

You can add the `Dispatcher` script to the autoloads list in Godot and use it globally or add it for scene that require high CPU usage.

### Basic
```gdscript
extends Node2D

@onready var _dispatcher := $Dispatcher as Dispatcher

func _ready() -> void:
    _dispatcher.post(_job)

func _job() -> void:
    print("fib(35) = ", _fibonacci(35))

func _fibonacci(n: int) -> int:
    if n <= 1:
        return n
    else:
        return _fibonacci(n - 1) + _fibonacci(n - 2)

```

### Cancellation Token

```gdscript
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
```

## License

This addon is licensed under the [MIT](LICENSE.md) License. 
