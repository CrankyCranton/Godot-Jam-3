extends VBoxContainer

func remove_task(task:int):
	if get_child_count() == 1:
		get_tree().quit()
	get_child(task).queue_free()
