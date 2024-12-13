extends VBoxContainer
 
func remove_task(task:int):
	get_child(task).queue_free()
