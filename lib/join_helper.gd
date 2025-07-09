class_name JoinHelper


signal one_done
signal done

var waiting: int

func _init():
	one_done.connect(_on_one_done)

func _on_one_done():
	waiting -= 1
	if waiting == 0:
		done.emit()


static func join(coroutines: Array[Callable]):
	var instance: JoinHelper = JoinHelper.new()
	instance.waiting = coroutines.size()

	for c in coroutines:
		var wrapper = func():
			await c.call()
			instance.one_done.emit()
		wrapper.call()

	return instance
